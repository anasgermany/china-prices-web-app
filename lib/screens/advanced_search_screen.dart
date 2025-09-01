import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../models/filter_model.dart';
import '../services/app_provider.dart';
import '../widgets/advanced_filter_widget.dart';
import '../widgets/product_card.dart';
import '../routes.dart';

class AdvancedSearchScreen extends StatefulWidget {
  const AdvancedSearchScreen({super.key});

  @override
  State<AdvancedSearchScreen> createState() => _AdvancedSearchScreenState();
}

class _AdvancedSearchScreenState extends State<AdvancedSearchScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _showFilters = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.applyFilter(ProductFilter());
    });
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Advanced Search',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppConstants.textPrimaryColor,
          ),
        ),
        backgroundColor: AppConstants.surfaceColor,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              _showFilters ? Icons.close : Icons.tune,
              color: AppConstants.primaryColor,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Consumer<AppProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              // Filter Widget - Fixed height when shown
              if (_showFilters)
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: AdvancedFilterWidget(
                    currentFilter: provider.currentFilter,
                    filterStats: provider.getFilterStats(),
                    availableCategories: provider.getAvailableCategories(),
                    onFilterChanged: (filter) async {
                      setState(() {
                        _isLoading = true;
                      });
                      await provider.applyFilter(filter);
                      setState(() {
                        _isLoading = false;
                      });
                    },
                    onClearFilters: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await provider.clearFilter();
                      setState(() {
                        _isLoading = false;
                      });
                    },
                  ),
                ),

              // Results Section - Takes remaining space
              Expanded(
                child: _buildResultsSection(provider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildResultsSection(AppProvider provider) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final products = provider.filteredProducts;

    if (products.isEmpty) {
      return _buildEmptyState(provider);
    }

    return Column(
      children: [
        // Results Header - Compact
        _buildResultsHeader(provider, products.length),
        
        // Products Grid - Takes most space
        Expanded(
          child: _buildProductsGrid(products),
        ),
      ],
    );
  }

  Widget _buildResultsHeader(AppProvider provider, int productCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.search,
              color: AppConstants.primaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$productCount Products Found',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.textPrimaryColor,
              ),
            ),
          ),
          if (provider.currentFilter.hasActiveFilters)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Filtered',
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductsGrid(List<dynamic> products) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
        final childAspectRatio = constraints.maxWidth > 600 ? 0.7 : 0.8;
        final spacing = constraints.maxWidth > 600 ? 12.0 : 8.0;
        final padding = constraints.maxWidth > 600 ? 12.0 : 8.0;

        return GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              showFavoriteButton: true,
              isFavorite: false,
              onFavoriteToggle: () async {
                final provider = Provider.of<AppProvider>(context, listen: false);
                final isFavorite = await provider.isFavorite(product.productId);
                if (isFavorite) {
                  await provider.removeFromFavorites(product.productId);
                } else {
                  await provider.addToFavorites(product);
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState(AppProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.search_off,
              size: 64,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No Products Found',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppConstants.textPrimaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            provider.currentFilter.hasActiveFilters
                ? 'Try adjusting your filters to find more products'
                : 'Start searching to discover amazing products',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppConstants.textSecondaryColor,
            ),
          ),
          const SizedBox(height: 24),
          if (provider.currentFilter.hasActiveFilters)
            ElevatedButton.icon(
              onPressed: () async {
                await provider.clearFilter();
                setState(() {
                  _showFilters = false;
                });
              },
              icon: const Icon(
                Icons.clear_all,
                color: Colors.white,
              ),
              label: Text(
                'Clear All Filters',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
