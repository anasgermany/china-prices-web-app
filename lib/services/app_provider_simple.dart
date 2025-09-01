import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/price_comparison_model.dart';
import '../models/navigation_history_model.dart';
import '../models/gamification_model.dart';
import '../models/filter_model.dart';
import '../constants/app_constants.dart';
import 'api_service.dart';
import 'web_storage_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final WebStorageService _storageService = WebStorageService();

  // State variables
  List<Product> _products = [];
  List<PriceComparison> _priceComparisons = [];
  List<Product> _searchResults = [];
  List<NavigationHistory> _navigationHistory = [];
  List<ProductRecommendation> _recommendations = [];
  ProductFilter _currentFilter = ProductFilter();
  List<Product> _filteredProducts = [];

  // Gamification
  List<Challenge> _challenges = [];
  List<GamificationBadge> _badges = [];
  UserPoints _userPoints = UserPoints(
    totalPoints: 0,
    currentPoints: 0,
    level: 1,
    pointsToNextLevel: 100,
    transactions: [],
  );
  ReferralSystem _referralSystem = ReferralSystem(
    referralCode: '',
    referrals: [],
    createdAt: DateTime.now(),
  );
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentJsonUrl = AppConstants.categoryJsonLinks.values.first;
  String _currentCategory = '';

  // Getters
  List<Product> get products => _products;
  List<PriceComparison> get priceComparisons => _priceComparisons;
  List<Product> get searchResults => _searchResults;
  List<NavigationHistory> get navigationHistory => _navigationHistory;
  List<ProductRecommendation> get recommendations => _recommendations;
  ProductFilter get currentFilter => _currentFilter;
  List<Product> get filteredProducts => _filteredProducts;

  // Gamification getters
  List<Challenge> get challenges => _challenges;
  List<GamificationBadge> get badges => _badges;
  UserPoints get userPoints => _userPoints;
  ReferralSystem get referralSystem => _referralSystem;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentJsonUrl => _currentJsonUrl;
  String get currentCategory => _currentCategory;

  // Initialize the app
  Future<void> initialize() async {
    try {
      _setLoading(true);
      print('AppProvider: Initializing app...');
      await _loadProducts();
      print('AppProvider: Products loaded: ${_searchResults.length}');

      // Load user data from storage
      await _loadUserData();
      print('AppProvider: User data loaded');
    } catch (e) {
      print('AppProvider: Error initializing app: $e');
      _setError('Error initializing app: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load user data from storage
  Future<void> _loadUserData() async {
    try {
      // Load favorites
      final favorites = await _storageService.getFavorites();
      print('AppProvider: Loaded ${favorites.length} favorites');

      // Load search history
      final searchHistory = await _storageService.getSearchHistory();
      print('AppProvider: Loaded ${searchHistory.length} search history items');

      // Load navigation history
      final navHistory = await _storageService.getNavigationHistory();
      print(
          'AppProvider: Loaded ${navHistory.length} navigation history items');

      // Load user preferences
      final preferences = await _storageService.getUserPreferences();
      print('AppProvider: Loaded user preferences');

      // Load gamification data
      final userPoints = await _storageService.getUserPoints();
      print('AppProvider: Loaded gamification data');

      // Update state with proper type conversion
      _userPoints = _userPoints.copyWith(totalPoints: userPoints);
    } catch (e) {
      print('AppProvider: Error loading user data: $e');
    }
  }

  // Load products from JSON
  Future<void> _loadProducts() async {
    try {
      print('AppProvider: Loading products from all category JSONs');

      // Get all unique JSON URLs from categories
      final Set<String> jsonUrls =
          AppConstants.categoryJsonLinks.values.toSet();
      print('AppProvider: Found ${jsonUrls.length} unique JSON URLs to load');

      List<Product> allProducts = [];

      // Load products from all category JSONs
      for (String jsonUrl in jsonUrls) {
        try {
          print('AppProvider: Loading products from: $jsonUrl');
          final products = await apiService.fetchProducts(jsonUrl);
          print(
              'AppProvider: Loaded ${products.length} products from $jsonUrl');
          allProducts.addAll(products);
        } catch (e) {
          print('AppProvider: Error loading from $jsonUrl: $e');
        }
      }

      _products = allProducts;
      print('AppProvider: Total products loaded: ${_products.length}');

      // Initialize search results with all products
      _searchResults = List.from(_products);
    } catch (e) {
      print('AppProvider: Error loading products: $e');
      _setError('Error loading products: $e');
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    print('AppProvider: Searching for "$query"');

    if (query.trim().isEmpty) {
      print('AppProvider: Empty query, clearing results');
      _searchResults = List.from(_products);
      notifyListeners();
      return _searchResults;
    }

    try {
      print('AppProvider: Searching in all category JSONs');

      // Get all unique JSON URLs from categories
      final Set<String> jsonUrls =
          AppConstants.categoryJsonLinks.values.toSet();
      print('AppProvider: Found ${jsonUrls.length} unique JSON URLs to search');

      List<Product> allProducts = [];

      // Load products from all category JSONs
      for (String jsonUrl in jsonUrls) {
        try {
          print('AppProvider: Loading products from: $jsonUrl');
          final products = await apiService.fetchProducts(jsonUrl);
          print(
              'AppProvider: Loaded ${products.length} products from $jsonUrl');
          allProducts.addAll(products);
        } catch (e) {
          print('AppProvider: Error loading from $jsonUrl: $e');
        }
      }

      print(
          'AppProvider: Total products loaded from all JSONs: ${allProducts.length}');

      // Improved search logic - search in product description more precisely
      final filteredProducts = allProducts.where((product) {
        final productName = product.productDesc.toLowerCase();
        final searchQuery = query.toLowerCase().trim();

        // Split search query into words for better matching
        final searchWords =
            searchQuery.split(' ').where((word) => word.isNotEmpty).toList();

        if (searchWords.isEmpty) return false;

        // Check if ALL search words are found in the product description
        bool allWordsFound = true;
        for (final word in searchWords) {
          if (!productName.contains(word)) {
            allWordsFound = false;
            break;
          }
        }

        // Also check for exact phrase match
        bool exactPhraseMatch = productName.contains(searchQuery);

        // Return true if either all words are found OR exact phrase matches
        return allWordsFound || exactPhraseMatch;
      }).toList();

      _searchResults = filteredProducts;
      print('AppProvider: Found ${_searchResults.length} results for "$query"');

      // Track search for gamification
      if (filteredProducts.isNotEmpty) {
        await trackSearchPerformed();
      }

      return filteredProducts;
    } catch (e) {
      print('AppProvider: Error searching products: $e');
      _setError('Error searching products: $e');
      return [];
    }
  }

  // Load products by category
  Future<void> loadProductsByCategory(String category) async {
    try {
      print('AppProvider: Loading products for category: $category');
      _setLoading(true);

      final categoryJsonUrl = AppConstants.categoryJsonLinks[category];
      String jsonUrl;

      if (categoryJsonUrl == null || categoryJsonUrl.isEmpty) {
        // Fallback to default JSON if no specific link found
        jsonUrl = AppConstants.categoryJsonLinks.values.first;
        print(
            'No JSON link found for category: $category, using default: $jsonUrl');
      } else {
        jsonUrl = categoryJsonUrl;
        print('Using category-specific JSON for $category: $jsonUrl');
      }

      // Load ALL products from the category-specific JSON without filtering
      List<Product> categoryProducts = [];

      try {
        print('Loading all products from category JSON: $jsonUrl');
        final allProducts = await apiService.fetchProducts(jsonUrl);
        print('Found ${allProducts.length} total products in category JSON');

        // Take a subset of products to avoid overwhelming the UI
        final maxProducts = AppConstants.maxCategoryProducts;
        if (allProducts.length > maxProducts) {
          print('Limiting to $maxProducts products for better UI performance');
          categoryProducts = allProducts.take(maxProducts).toList();
        } else {
          categoryProducts = allProducts;
        }
      } catch (e) {
        print('Error loading products from category JSON: $e');

        // If category-specific JSON fails, try with default JSON
        try {
          print('Trying default JSON as fallback...');
          final defaultProducts = await apiService
              .fetchProducts(AppConstants.categoryJsonLinks.values.first);
          print('Found ${defaultProducts.length} products in default JSON');

          final maxProducts = AppConstants.maxCategoryProducts;
          if (defaultProducts.length > maxProducts) {
            categoryProducts = defaultProducts.take(maxProducts).toList();
          } else {
            categoryProducts = defaultProducts;
          }
        } catch (fallbackError) {
          print('Fallback JSON also failed: $fallbackError');
          categoryProducts = [];
        }
      }

      print(
          'Total products loaded for category "$category": ${categoryProducts.length}');

      _searchResults = categoryProducts;
      notifyListeners();
    } catch (e) {
      print('AppProvider: Error loading products by category: $e');
      _setError('Error loading products by category: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Launch product URL
  Future<void> launchProductUrl(String url) async {
    try {
      print('AppProvider: Launching URL: $url');

      // For web, we'll use window.open
      if (url.isNotEmpty) {
        // This will be handled by the UI layer
        print('AppProvider: URL ready for launch: $url');
      }
    } catch (e) {
      print('AppProvider: Error launching URL: $e');
      _setError('Error launching URL: $e');
    }
  }

  // Favorites methods
  Future<void> addToFavorites(Product product) async {
    try {
      print(
          'AppProvider: Adding product to favorites: ${product.productDesc} (ID: ${product.productId})');
      await _storageService.addToFavorites(product.productId.toString());

      // Track for gamification
      await trackFavoriteAdded();

      print(
          'AppProvider: Successfully added to favorites, notifying listeners');
      notifyListeners();
    } catch (e) {
      print('AppProvider: Error adding to favorites: $e');
      _setError('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    try {
      await _storageService.removeFromFavorites(productId.toString());
      notifyListeners();
    } catch (e) {
      print('Error removing from favorites: $e');
      _setError('Error removing from favorites: $e');
    }
  }

  Future<List<String>> getFavorites() async {
    try {
      print('AppProvider: Getting favorites from storage service...');
      final favorites = await _storageService.getFavorites();
      print(
          'AppProvider: Retrieved ${favorites.length} favorites from storage');
      return favorites;
    } catch (e) {
      print('AppProvider: Error getting favorites: $e');
      return <String>[];
    }
  }

  Future<bool> isFavorite(int productId) async {
    try {
      return await _storageService.isFavorite(productId.toString());
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Search history methods
  Future<void> addToSearchHistory(String query) async {
    try {
      await _storageService.addToSearchHistory(query);
    } catch (e) {
      print('Error adding to search history: $e');
    }
  }

  Future<List<String>> getSearchHistory() async {
    try {
      return await _storageService.getSearchHistory();
    } catch (e) {
      print('Error getting search history: $e');
      return <String>[];
    }
  }

  void clearSearchHistory() async {
    try {
      await _storageService.clearSearchHistory();
      notifyListeners();
    } catch (e) {
      print('Error clearing search history: $e');
    }
  }

  // Navigation History Methods
  Future<void> addToNavigationHistory(Product product, String category) async {
    try {
      print(
          'AppProvider: Adding product to navigation history: ${product.productDesc}');
      await _storageService.addToNavigationHistory(
        '/product-detail',
        product.productDesc,
        data: {
          'productId': product.productId,
          'category': category,
        },
      );
      await _loadNavigationHistory();
      await _generateRecommendations();
    } catch (e) {
      print('AppProvider: Error adding to navigation history: $e');
    }
  }

  Future<void> _loadNavigationHistory() async {
    try {
      final historyData = await _storageService.getNavigationHistory();
      _navigationHistory = historyData.map((item) {
        return NavigationHistory(
          productId: item['data']?['productId']?.toString() ?? '',
          productName: item['title'] ?? '',
          imageUrl: item['data']?['imageUrl'] ?? '',
          category: item['data']?['category'] ?? '',
          viewedAt:
              DateTime.tryParse(item['timestamp'] ?? '') ?? DateTime.now(),
          viewCount: 1,
        );
      }).toList();
      notifyListeners();
    } catch (e) {
      print('AppProvider: Error loading navigation history: $e');
    }
  }

  Future<void> clearNavigationHistory() async {
    try {
      await _storageService.clearNavigationHistory();
      _navigationHistory = [];
      _recommendations = [];
      notifyListeners();
    } catch (e) {
      print('AppProvider: Error clearing navigation history: $e');
    }
  }

  // Generate recommendations
  Future<void> _generateRecommendations() async {
    try {
      // Generate random recommendations from all available products
      final List<ProductRecommendation> recommendations = [];

      // Ensure we always have products to recommend
      if (_products.isEmpty) {
        print(
            'AppProvider: No products available, creating empty recommendations');
        _recommendations = [];
        notifyListeners();
        return;
      }

      // Create a copy of products and shuffle them
      final List<Product> shuffledProducts = List.from(_products);
      shuffledProducts.shuffle();

      // Take first 5 random products for recommendations (or all if less than 5)
      final randomProducts = shuffledProducts.take(5).toList();

      // Define some random reasons for recommendations
      final List<String> recommendationReasons = [
        'Trending now',
        'Best seller',
        'Great value',
        'Popular choice',
        'Premium quality',
      ];

      // Get available categories for better variety
      final availableCategories = getAvailableCategories();

      for (int i = 0; i < randomProducts.length; i++) {
        final product = randomProducts[i];
        final reason = recommendationReasons[i % recommendationReasons.length];

        // Generate a random score between 4.0 and 5.0
        final randomScore = 4.0 +
            (i * 0.2) +
            (DateTime.now().millisecondsSinceEpoch % 100) / 100.0;
        final score = randomScore.clamp(4.0, 5.0);

        // Determine category from product description
        final category = _getProductCategory(product);

        recommendations.add(ProductRecommendation(
          productId: product.productId.toString(),
          productName: product.productDesc,
          imageUrl: product.imageUrl,
          category: category,
          score: score,
          reason: reason,
        ));
      }

      _recommendations = recommendations;
      notifyListeners();
      print(
          'AppProvider: Generated ${_recommendations.length} random recommendations from ${_products.length} total products');
      print(
          'AppProvider: Available categories: ${availableCategories.join(', ')}');
    } catch (e) {
      print('AppProvider: Error generating recommendations: $e');
    }
  }

  // Get product category
  String _getProductCategory(Product product) {
    final desc = product.productDesc.toLowerCase();

    // Categorías específicas
    if (desc.contains('phone') ||
        desc.contains('cellphone') ||
        desc.contains('mobile') ||
        desc.contains('smartphone') ||
        desc.contains('iphone') ||
        desc.contains('android')) {
      return 'Cellphone';
    } else if (desc.contains('clothes') ||
        desc.contains('shirt') ||
        desc.contains('pants') ||
        desc.contains('dress') ||
        desc.contains('suit') ||
        desc.contains('jacket') ||
        desc.contains('fashion') ||
        desc.contains('wear')) {
      return 'Clothing';
    } else if (desc.contains('toy') ||
        desc.contains('car') ||
        desc.contains('model') ||
        desc.contains('game') ||
        desc.contains('play')) {
      return 'Toys';
    } else if (desc.contains('electronic') ||
        desc.contains('laptop') ||
        desc.contains('computer') ||
        desc.contains('tablet') ||
        desc.contains('camera') ||
        desc.contains('headphone')) {
      return 'Electronics';
    } else if (desc.contains('automotive') ||
        desc.contains('car') ||
        desc.contains('vehicle') ||
        desc.contains('motorcycle') ||
        desc.contains('bike')) {
      return 'Automotive';
    } else if (desc.contains('sport') ||
        desc.contains('fitness') ||
        desc.contains('exercise') ||
        desc.contains('gym') ||
        desc.contains('running')) {
      return 'Sports';
    } else if (desc.contains('home') ||
        desc.contains('kitchen') ||
        desc.contains('garden') ||
        desc.contains('furniture') ||
        desc.contains('decoration')) {
      return 'Home & Garden';
    } else if (desc.contains('beauty') ||
        desc.contains('cosmetic') ||
        desc.contains('makeup') ||
        desc.contains('skincare') ||
        desc.contains('perfume')) {
      return 'Beauty';
    } else if (desc.contains('book') ||
        desc.contains('magazine') ||
        desc.contains('reading')) {
      return 'Books';
    } else if (desc.contains('health') ||
        desc.contains('medical') ||
        desc.contains('vitamin')) {
      return 'Health';
    }

    return 'General';
  }

  // Get available categories
  List<String> getAvailableCategories() {
    final categories = _products
        .map((product) => _getProductCategory(product))
        .toSet()
        .toList();
    categories.sort();
    return categories;
  }

  // Track search performed
  Future<void> trackSearchPerformed() async {
    print('AppProvider: Search performed tracked');
  }

  // Track favorite added
  Future<void> trackFavoriteAdded() async {
    print('AppProvider: Favorite added tracked');
  }

  // Track product viewed
  Future<void> trackProductViewed() async {
    print('AppProvider: Product viewed tracked');
  }

  // Track app click for analytics
  Future<void> trackAppClick() async {
    // Track app click for analytics
    print('AppProvider: Tracking app click for analytics');
  }

  // Get current click count (for debugging)
  int get clickCount => 0; // No longer tracking clicks

  // Reset click count (for testing)
  Future<void> resetClickCount() async {
    // No longer tracking clicks
    print('AppProvider: Click count reset (not tracking clicks)');
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
