import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../constants/app_constants.dart';
import '../services/app_provider.dart';
import '../widgets/product_card.dart';
import '../models/product_model.dart';


class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;
  final List<String> searchTerms;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.searchTerms,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen>
    with TickerProviderStateMixin {
  List<Product> _products = [];
  bool _isLoading = true;
  String _errorMessage = '';
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _loadCategoryProducts();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _loadCategoryProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final provider = Provider.of<AppProvider>(context, listen: false);
      
      // Get the specific JSON link for this category
      final categoryJsonUrl = AppConstants.categoryJsonLinks[widget.categoryName];
      String jsonUrl;
      
      if (categoryJsonUrl == null || categoryJsonUrl.isEmpty) {
        // Fallback to default JSON if no specific link found
        jsonUrl = AppConstants.categoryJsonLinks.values.first;
        print('No JSON link found for category: ${widget.categoryName}, using default: $jsonUrl');
      } else {
        jsonUrl = categoryJsonUrl;
        print('Using category-specific JSON for ${widget.categoryName}: $jsonUrl');
      }
      
      // Load ALL products from the category-specific JSON without filtering
      List<dynamic> allProducts = [];
      
      try {
        print('Loading all products from category JSON: $jsonUrl');
        final products = await provider.apiService.fetchProducts(jsonUrl);
        print('Found ${products.length} total products in category JSON');
        
        // Take a subset of products to avoid overwhelming the UI
        final maxProducts = AppConstants.maxCategoryProducts;
        if (products.length > maxProducts) {
          allProducts = products.take(maxProducts).toList();
          print('Limited to $maxProducts products for better performance');
        } else {
          allProducts = products;
        }
        
      } catch (e) {
        print('Error loading products from category JSON: $e');
        
        // If category-specific JSON fails, try with default JSON
        try {
          print('Trying default JSON as fallback...');
          final defaultProducts = await provider.apiService.fetchProducts(AppConstants.categoryJsonLinks.values.first);
          print('Found ${defaultProducts.length} products in default JSON');
          
          final maxProducts = AppConstants.maxCategoryProducts;
          if (defaultProducts.length > maxProducts) {
            allProducts = defaultProducts.take(maxProducts).toList();
          } else {
            allProducts = defaultProducts;
          }
        } catch (defaultError) {
          print('Error loading from default JSON: $defaultError');
          throw Exception('Could not load products from any JSON source');
        }
      }
      
      print('Total products loaded for category "${widget.categoryName}": ${allProducts.length}');
      
      // Shuffle products
      final random = Random();
      _products = List.from(allProducts)..shuffle(random);
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error in _loadCategoryProducts for "${widget.categoryName}": $e');
      setState(() {
        _errorMessage = 'Error loading products: $e';
        _isLoading = false;
      });
    }
  }

  void _shuffleProducts() {
    if (_products.isNotEmpty) {
      final random = Random();
      setState(() {
        _products = List.from(_products)..shuffle(random);
      });
      
      // Show feedback
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppConstants.productsShuffled,
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppConstants.successColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Text(
              widget.categoryName,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shuffle, color: Colors.white),
            onPressed: () {
              _shuffleProducts();
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadCategoryProducts,
          ),
        ],
      ),
      body: Column(
        children: [
          // Content
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return _buildLoadingState();
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorState();
    }

    if (_products.isEmpty) {
      return _buildEmptyState();
    }

    return _buildProductsGrid();
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryColor),
          ).animate().scale(duration: 600.ms).then().shake(),
          const SizedBox(height: 16),
          Text(
            'Loading ${widget.categoryName}...',
            style: GoogleFonts.poppins(
              color: AppConstants.textSecondaryColor,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: AppConstants.errorColor,
          ).animate().scale(duration: 600.ms).then().shake(),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
          const SizedBox(height: 8),
          Text(
            _errorMessage,
            style: GoogleFonts.poppins(
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadCategoryProducts,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
            ),
            child: Text(
              'Try Again',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category_outlined,
            size: 64,
            color: AppConstants.textSecondaryColor.withOpacity(0.5),
          ).animate().scale(duration: 600.ms).then().shake(),
          const SizedBox(height: 16),
          Text(
            'No ${widget.categoryName} Found',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.textPrimaryColor,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.3),
          const SizedBox(height: 8),
          Text(
            'Try searching for a different category\nor check back later',
            style: GoogleFonts.poppins(
              color: AppConstants.textSecondaryColor,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
        ],
      ),
    );
  }

  Widget _buildProductsGrid() {
    return Column(
      children: [
        // Products Grid
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Calculate responsive grid parameters
              final screenWidth = constraints.maxWidth;
              final screenHeight = constraints.maxHeight;
              
              // Determine cross axis count based on screen width
              int crossAxisCount = 2;
              if (screenWidth > 600) {
                crossAxisCount = 3;
              }
              if (screenWidth > 900) {
                crossAxisCount = 4;
              }
              
              // Calculate responsive spacing
              final spacing = screenWidth * 0.02; // 2% of screen width
              final padding = screenWidth * 0.04; // 4% of screen width
              
              // Calculate responsive child aspect ratio
              double childAspectRatio = 0.65; // Make cards taller by default
              if (screenWidth < 400) {
                childAspectRatio = 0.6; // Even taller cards on small screens
              } else if (screenWidth > 600) {
                childAspectRatio = 0.7; // Slightly taller cards on large screens
              }
              
              return GridView.builder(
                padding: EdgeInsets.all(padding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  childAspectRatio: childAspectRatio,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  
                  return ProductCard(
                    product: product,
                    showFavoriteButton: true,
                    isFavorite: false, // Will be updated by ProductCard
                    onFavoriteToggle: () async {
                      print('CategoryProductsScreen: Favorite toggle callback called');
                      // The ProductCard will handle the favorite toggle internally
                      // This callback is just for additional UI updates if needed
                    },
                  ).animate().fadeIn(
                    delay: (index * 50).ms,
                    duration: 400.ms,
                  ).slideY(
                    begin: 0.3,
                    delay: (index * 50).ms,
                    duration: 400.ms,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
