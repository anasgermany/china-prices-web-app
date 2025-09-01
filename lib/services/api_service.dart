import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../models/price_comparison_model.dart';
import '../constants/app_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<List<Product>> fetchProducts(String jsonUrl) async {
    try {
      print('Fetching products from: $jsonUrl');
      
      if (jsonUrl.isEmpty) {
        print('Empty JSON URL provided');
        return [];
      }
      
      final response = await http.get(Uri.parse(jsonUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );
      
      print('Response status code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Successfully parsed ${jsonData.length} products from JSON');
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        print('HTTP error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching products from $jsonUrl: $e');
      throw Exception('Error fetching products: $e');
    }
  }

  Future<List<PriceComparison>> fetchPriceComparisons(String jsonUrl) async {
    try {
      final response = await http.get(Uri.parse(jsonUrl));
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => PriceComparison.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load price comparisons: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching price comparisons: $e');
    }
  }

  Future<List<Product>> searchProducts(String query, String jsonUrl) async {
    try {
      print('Searching for "$query" in: $jsonUrl');
      
      final products = await fetchProducts(jsonUrl);
      
      if (products.isEmpty) {
        print('No products found in JSON');
        return [];
      }
      
      if (query.isEmpty) {
        print('Empty query, returning all ${products.length} products');
        return products;
      }
      
      final filteredProducts = products.where((product) {
        final productName = product.productDesc.toLowerCase();
        final searchQuery = query.toLowerCase();
        return productName.contains(searchQuery);
      }).toList();
      
      print('Found ${filteredProducts.length} products matching "$query"');
      return filteredProducts;
    } catch (e) {
      print('Error searching products for "$query": $e');
      throw Exception('Error searching products: $e');
    }
  }

  Future<List<PriceComparison>> searchPriceComparisons(String query, String jsonUrl) async {
    try {
      final comparisons = await fetchPriceComparisons(jsonUrl);
      
      if (query.isEmpty) return comparisons;
      
      return comparisons.where((comparison) {
        final productName = comparison.name.toLowerCase();
        final searchQuery = query.toLowerCase();
        return productName.contains(searchQuery);
      }).toList();
    } catch (e) {
      throw Exception('Error searching price comparisons: $e');
    }
  }

  // Generate default store URLs for products not found in specific stores
  List<StorePrice> generateDefaultStorePrices(String productName) {
    final List<StorePrice> defaultPrices = [];
    
    AppConstants.storeUrls.forEach((storeName, baseUrl) {
      String searchUrl;
      
      if (storeName == 'VIP.com') {
        searchUrl = '$baseUrl${Uri.encodeComponent(productName)}.html';
      } else {
        searchUrl = '$baseUrl${Uri.encodeComponent(productName)}';
      }
      
      defaultPrices.add(StorePrice(
        storeName: storeName,
        price: 0.0, // Price unknown
        affiliateUrl: searchUrl,
      ));
    });
    
    return defaultPrices;
  }

  // Create a price comparison from a single product
  PriceComparison createPriceComparisonFromProduct(Product product) {
    final List<StorePrice> prices = [];
    
    // Add AliExpress price (always first)
    prices.add(StorePrice(
      storeName: 'AliExpress',
      price: product.numericPrice,
      affiliateUrl: product.promotionUrl,
    ));
    
    // Generate default prices for other stores
    final defaultPrices = generateDefaultStorePrices(product.productDesc);
    prices.addAll(defaultPrices.where((price) => price.storeName != 'AliExpress'));
    
    return PriceComparison(
      name: product.productDesc,
      imageUrl: product.imageUrl,
      prices: prices,
    );
  }
}
