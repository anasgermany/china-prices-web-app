import 'package:flutter/material.dart';
import 'dart:math';
import '../models/product_model.dart';
import '../constants/app_constants.dart';
import 'api_service.dart';

class AppProvider extends ChangeNotifier {
  final ApiService apiService = ApiService();
  final Random _random = Random();

  // State variables
  List<Product> _products = [];
  List<Product> _searchResults = [];
  List<Product> _favorites = []; // Local favorites list
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  List<Product> get products => _products;
  List<Product> get searchResults => _searchResults;
  List<Product> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // Initialize the app
  Future<void> initialize() async {
    try {
      _setLoading(true);
      print('AppProvider: Initializing app...');
      await _loadProducts();
      print('AppProvider: Products loaded: ${_searchResults.length}');
    } catch (e) {
      print('AppProvider: Error initializing app: $e');
      _setError('Error initializing app: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load products from JSON with dynamic shuffling
  Future<void> _loadProducts() async {
    try {
      print('AppProvider: Loading fresh products from all category JSONs...');

      // Get all unique JSON URLs from editableCategories
      final Set<String> jsonUrls = AppConstants.editableCategories
          .map((cat) => cat['jsonUrl'] as String)
          .where((url) => url.isNotEmpty)
          .toSet();
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

      // Shuffle products for variety
      allProducts.shuffle(_random);
      print('AppProvider: Shuffled ${allProducts.length} products for variety');

      _products = allProducts;
      print(
          'AppProvider: Total products loaded and shuffled: ${_products.length}');

      // Initialize search results with shuffled products
      _searchResults = List.from(_products);
    } catch (e) {
      print('AppProvider: Error loading products: $e');
      _setError('Error loading products: $e');
    }
  }

  // Refresh products - always loads fresh data
  Future<void> refreshProducts() async {
    try {
      print('AppProvider: Refreshing products...');
      _setLoading(true);
      await _loadProducts();
      print('AppProvider: Products refreshed successfully');
    } catch (e) {
      print('AppProvider: Error refreshing products: $e');
      _setError('Error refreshing products: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search products with fresh data
  Future<List<Product>> searchProducts(String query) async {
    print('AppProvider: Searching for "$query" with fresh data...');

    if (query.trim().isEmpty) {
      print('AppProvider: Empty query, refreshing and showing all products');
      await refreshProducts();
      return _searchResults;
    }

    try {
      print('AppProvider: Loading fresh data for search...');

      // Get all unique JSON URLs from editableCategories
      final Set<String> jsonUrls = AppConstants.editableCategories
          .map((cat) => cat['jsonUrl'] as String)
          .where((url) => url.isNotEmpty)
          .toSet();
      print('AppProvider: Found ${jsonUrls.length} unique JSON URLs to search');

      List<Product> allProducts = [];

      // Load fresh products from all category JSONs
      for (String jsonUrl in jsonUrls) {
        try {
          print('AppProvider: Loading fresh products from: $jsonUrl');
          final products = await apiService.fetchProducts(jsonUrl);
          print(
              'AppProvider: Loaded ${products.length} fresh products from $jsonUrl');
          allProducts.addAll(products);
        } catch (e) {
          print('AppProvider: Error loading from $jsonUrl: $e');
        }
      }

      print(
          'AppProvider: Total fresh products loaded from all JSONs: ${allProducts.length}');

      // Shuffle products for variety
      allProducts.shuffle(_random);
      print('AppProvider: Shuffled products for search variety');

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

      // Shuffle search results for variety
      filteredProducts.shuffle(_random);

      _searchResults = filteredProducts;
      print(
          'AppProvider: Found and shuffled ${_searchResults.length} results for "$query"');

      return filteredProducts;
    } catch (e) {
      print('AppProvider: Error searching products: $e');
      _setError('Error searching products: $e');
      return [];
    }
  }

  // Load products by category with fresh data
  Future<void> loadProductsByCategory(String category) async {
    try {
      print('AppProvider: Loading fresh products for category: $category');
      _setLoading(true);

      // Find the category in editableCategories
      final categoryData = AppConstants.editableCategories.firstWhere(
        (cat) => cat['name'] == category,
        orElse: () => {'jsonUrl': ''},
      );

      String jsonUrl = categoryData['jsonUrl'] ?? '';

      if (jsonUrl.isEmpty) {
        // Fallback to first available JSON if no specific link found
        jsonUrl = AppConstants.editableCategories.first['jsonUrl'] ?? '';
        print(
            'No JSON link found for category: $category, using default: $jsonUrl');
      } else {
        print('Using category-specific JSON for $category: $jsonUrl');
      }

      // Load products from the category-specific JSON
      List<Product> categoryProducts = [];

      try {
        print('Loading fresh products from category JSON: $jsonUrl');
        final allProducts = await apiService.fetchProducts(jsonUrl);
        print(
            'Found ${allProducts.length} fresh products in category JSON for $category');

        // Shuffle products for variety
        allProducts.shuffle(_random);
        print(
            'AppProvider: Shuffled ${allProducts.length} category products for variety');

        // Take a subset of products to avoid overwhelming the UI
        final maxProducts = AppConstants.maxCategoryProducts;
        if (allProducts.length > maxProducts) {
          print(
              'Limiting to $maxProducts shuffled products for better UI performance');
          categoryProducts = allProducts.take(maxProducts).toList();
        } else {
          categoryProducts = allProducts;
        }
      } catch (e) {
        print('Error loading products from category JSON: $e');

        // If category-specific JSON fails, try with default JSON
        try {
          print('Trying default JSON as fallback...');
          final defaultProducts = await apiService.fetchProducts(
              AppConstants.editableCategories.first['jsonUrl'] ?? '');
          print(
              'Found ${defaultProducts.length} fresh products in default JSON');

          // Shuffle default products
          defaultProducts.shuffle(_random);

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
          'Total fresh and shuffled products loaded for category "$category": ${categoryProducts.length}');

      _searchResults = categoryProducts;
      notifyListeners();
    } catch (e) {
      print('AppProvider: Error loading products by category: $e');
      _setError('Error loading products by category: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get random products for variety
  List<Product> getRandomProducts(int count) {
    if (_products.isEmpty) return [];

    // Create a copy and shuffle for variety
    final shuffledProducts = List<Product>.from(_products);
    shuffledProducts.shuffle(_random);

    return shuffledProducts.take(count).toList();
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

  // Favorites methods (working with local list)
  Future<void> addToFavorites(Product product) async {
    try {
      print(
          'AppProvider: Adding product to favorites: ${product.productDesc} (ID: ${product.productId})');

      // Check if already in favorites
      if (!_favorites.any((p) => p.productId == product.productId)) {
        _favorites.add(product);
        print(
            'AppProvider: Successfully added to favorites, total: ${_favorites.length}');
        notifyListeners();
      } else {
        print('AppProvider: Product already in favorites');
      }
    } catch (e) {
      print('AppProvider: Error adding to favorites: $e');
      _setError('Error adding to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    try {
      print('AppProvider: Removing product from favorites: $productId');
      _favorites.removeWhere((product) => product.productId == productId);
      notifyListeners();
    } catch (e) {
      print('Error removing from favorites: $e');
      _setError('Error removing from favorites: $e');
    }
  }

  Future<List<Product>> getFavorites() async {
    try {
      print('AppProvider: Getting favorites...');
      return _favorites;
    } catch (e) {
      print('AppProvider: Error getting favorites: $e');
      return <Product>[];
    }
  }

  Future<bool> isFavorite(int productId) async {
    try {
      return _favorites.any((product) => product.productId == productId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Search history methods (simplified for web)
  Future<void> addToSearchHistory(String query) async {
    try {
      print('AppProvider: Adding to search history: $query');
    } catch (e) {
      print('Error adding to search history: $e');
    }
  }

  Future<List<String>> getSearchHistory() async {
    try {
      // For web, return empty list for now
      return <String>[];
    } catch (e) {
      print('Error getting search history: $e');
      return <String>[];
    }
  }

  void clearSearchHistory() async {
    try {
      print('AppProvider: Clearing search history');
      notifyListeners();
    } catch (e) {
      print('Error clearing search history: $e');
    }
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
