import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/app_constants.dart';
import '../services/app_provider_web.dart';
import '../widgets/product_card_simple.dart';
import '../models/product_model.dart';
import '../routes.dart';
import '../services/web_url_service.dart';
import '../services/analytics_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedCategory = 'All';
  bool _isSearchBarVisible = true;
  double _lastScrollPosition = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<AppProvider>(context, listen: false);
      provider.initialize();

      // Track page view for analytics
      AnalyticsService.trackPageView(
        pageName: 'home_screen',
        pageTitle: 'China Prices - Home',
        parameters: {
          'screen_type': 'home',
          'user_type': 'visitor',
        },
      );
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final currentPosition = _scrollController.position.pixels;
    final isScrollingUp = currentPosition < _lastScrollPosition;
    
    // Only hide/show if there's a significant scroll change
    if ((currentPosition - _lastScrollPosition).abs() > 10) {
      if (isScrollingUp && !_isSearchBarVisible) {
        // Show search bar when scrolling up
        setState(() {
          _isSearchBarVisible = true;
        });
      } else if (!isScrollingUp && _isSearchBarVisible && currentPosition > 100) {
        // Hide search bar when scrolling down (but only after scrolling past 100px)
        setState(() {
          _isSearchBarVisible = false;
        });
      }
    }
    
    _lastScrollPosition = currentPosition;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Refresh products when app becomes visible again
    if (state == AppLifecycleState.resumed) {
      print('HomeScreen: App resumed, refreshing products...');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final provider = Provider.of<AppProvider>(context, listen: false);
        provider.refreshProducts();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          AppConstants.appName,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, AppRoutes.favorites),
            tooltip: 'My Favorites',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshProducts(),
            tooltip: 'Refresh Products',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Enhanced Search Bar with Attractive Design
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isSearchBarVisible ? 80 : 0,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                    decoration: InputDecoration(
                      hintText: '🔍 Search for products, categories, brands...',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                      prefixIcon: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppConstants.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.search,
                          color: AppConstants.primaryColor,
                          size: 24,
                        ),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? Container(
                              margin: EdgeInsets.all(8),
                              child: IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  _onSearchChanged('');
                                },
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: AppConstants.primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    onSubmitted: _onSearchSubmitted,
                    onChanged: _onSearchChanged,
                  ),
                ),
              ),

              // Search Help Text
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isSearchBarVisible ? 40 : 0,
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: Colors.orange[600],
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '💡 Tip: Search for "drones", "dresses", "phones", "shoes" or any product you want!',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Search Results Header
              if (_searchController.text.isNotEmpty) ...[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                          color: AppConstants.primaryColor, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Search results for "${_searchController.text}"',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      Spacer(),
                      Consumer<AppProvider>(
                        builder: (context, provider, child) {
                          return Text(
                            '${provider.searchResults.length} products found',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],

              // Google Play Download Banner
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isSearchBarVisible ? 80 : 0,
                child: _buildGooglePlayBanner(),
              ),

              // Categories
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _isSearchBarVisible ? 60 : 0,
                child: _buildCategoriesSection(),
              ),

              // Products Grid
              Expanded(
                child: Consumer<AppProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: AppConstants.primaryColor,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Loading products...',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    if (provider.errorMessage.isNotEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Error loading products',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.red[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              provider.errorMessage,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => provider.refreshProducts(),
                              child: Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final products = provider.searchResults;

                    if (products.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No products found',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey[700],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Try adjusting your search terms or browse all categories',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                _searchController.clear();
                                provider.refreshProducts();
                              },
                              child: Text('Show All Products'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstants.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(context),
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCardSimple(
                          product: product,
                          onTap: () => _onProductTap(product),
                          onFavoriteToggle: () => _onFavoriteToggle(product),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          
          // Floating Action Button to show/hide search bar
          if (!_isSearchBarVisible)
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                onPressed: () {
                  setState(() {
                    _isSearchBarVisible = true;
                  });
                  // Scroll to top to show the search bar
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Icon(Icons.search),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      'All',
      'Fashion',
      'Electronics',
      'Home',
      'Beauty',
      'Sports'
    ];

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category;

          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(
                category,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color:
                      isSelected ? Colors.white : AppConstants.textPrimaryColor,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
                _onCategorySelected(category);
              },
              backgroundColor: Colors.grey[200],
              selectedColor: AppConstants.primaryColor,
              checkmarkColor: Colors.white,
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        },
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 800) return 3;
    if (width > 600) return 2;
    return 1;
  }

  void _onSearchSubmitted(String query) async {
    print('HomeScreen: Search submitted: $query');

    final provider = Provider.of<AppProvider>(context, listen: false);

    if (query.trim().isEmpty) {
      // If search is empty, refresh all products
      await provider.refreshProducts();
    } else {
      // Search with fresh data
      await provider.searchProducts(query);

      // Track search for analytics
      AnalyticsService.trackSearch(
        searchTerm: query,
        resultCount: provider.searchResults.length,
        category: _selectedCategory != 'All' ? _selectedCategory : null,
      );
    }

    // Force UI refresh
    setState(() {});
  }

  void _onSearchChanged(String query) async {
    print('HomeScreen: Search changed: $query');

    if (query.trim().isEmpty) {
      // If search is empty, refresh all products
      final provider = Provider.of<AppProvider>(context, listen: false);
      await provider.refreshProducts();
      setState(() {});
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });

    print('HomeScreen: Category selected: $category');

    final provider = Provider.of<AppProvider>(context, listen: false);

    if (category == 'All') {
      // For "All" category, refresh all products
      provider.refreshProducts();
    } else {
      // For specific categories, load fresh products
      provider.loadProductsByCategory(category);
    }

    // Track category selection for analytics
    AnalyticsService.trackEvent(
      eventName: 'category_selected',
      parameters: {
        'category_name': category,
        'screen': 'home',
      },
    );
  }

  void _onProductTap(Product product) {
    // Track product view for analytics
    AnalyticsService.trackProductInteraction(
      productId: product.productId,
      action: 'view',
      productName: product.productDesc,
      category: _selectedCategory != 'All' ? _selectedCategory : null,
      price: product.numericPrice.toDouble(),
    );

    Navigator.pushNamed(
      context,
      AppRoutes.productDetail,
      arguments: product,
    );
  }

  void _onFavoriteToggle(Product product) {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.addToFavorites(product);
  }

  void _refreshProducts() {
    final provider = Provider.of<AppProvider>(context, listen: false);
    provider.refreshProducts();
  }

  Widget _buildGooglePlayBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _launchGooglePlayStore(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(
                  Icons.play_circle_filled,
                  color: Colors.white,
                  size: 24,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GET IT ON',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                          letterSpacing: 1.2,
                        ),
                      ),
                      Text(
                        'Google Play',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _launchGooglePlayStore() {
    final googlePlayUrl =
        'https://play.google.com/store/apps/details?id=com.marconlineshopping.humanhairwigs';

    // For web, we'll use the WebUrlService to open in new tab
    WebUrlService.openUrlInNewTab(googlePlayUrl).then((success) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening Google Play Store...'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening Google Play Store'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }
}
