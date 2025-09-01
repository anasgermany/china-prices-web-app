class CategoriesConfig {
  // ========================================
  // NEW CATEGORIES CONFIGURATION
  // ========================================
  
  /// All available categories with their JSON URLs and metadata
  static const List<Map<String, dynamic>> allCategories = [
    {
      'name': 'Drones & RC',
      'description': 'Professional drones, RC toys, and aerial photography equipment',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1579829366248-204fe8413f31?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/Drone.json',
      'color': 0xFF2196F3,
      'productCount': 0, // Will be updated dynamically
      'tags': ['drone', 'rc', 'aerial', 'photography', 'toy'],
    },
    {
      'name': 'Evening Dresses',
      'description': 'Elegant evening dresses and formal wear for special occasions',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/EveningDress.json',
      'color': 0xFFE91E63,
      'productCount': 0,
      'tags': ['dress', 'evening', 'formal', 'elegant', 'occasion'],
    },
    {
      'name': 'Phone Cases',
      'description': 'Stylish and protective phone cases for all smartphone models',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1603313011108-4f2d0c0c5c1c?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/phonecases2.json',
      'color': 0xFF9C27B0,
      'productCount': 0,
      'tags': ['phone', 'case', 'protection', 'style', 'smartphone'],
    },
    {
      'name': 'Men Jeans',
      'description': 'High-quality jeans and denim wear for men',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/menjeans200.json',
      'color': 0xFF795548,
      'productCount': 0,
      'tags': ['jeans', 'men', 'denim', 'casual', 'fashion'],
    },
    {
      'name': 'Plus Size Clothes',
      'description': 'Fashionable clothing for plus size women and men',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/plussizeclothes1.json',
      'color': 0xFFFF9800,
      'productCount': 0,
      'tags': ['plus size', 'fashion', 'clothing', 'inclusive', 'style'],
    },
    {
      'name': 'Smartphones',
      'description': 'Latest smartphones and mobile devices with great deals',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/smartphone1.json',
      'color': 0xFF607D8B,
      'productCount': 0,
      'tags': ['smartphone', 'phone', 'mobile', 'tech', 'device'],
    },
    {
      'name': 'Plus Size Dresses',
      'description': 'Beautiful dresses designed specifically for plus size women',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/womenplussizedresses.json',
      'color': 0xFFE91E63,
      'productCount': 0,
      'tags': ['dress', 'plus size', 'women', 'fashion', 'elegant'],
    },
    {
      'name': 'Kids Toys',
      'description': 'Fun and educational toys for children of all ages',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/Kidstoysshufles2.json',
      'color': 0xFFFF5722,
      'productCount': 0,
      'tags': ['toys', 'kids', 'children', 'fun', 'educational'],
    },
    {
      'name': 'Wedding Dresses',
      'description': 'Stunning wedding dresses for the most special day',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WeddingDresses.json',
      'color': 0xFFF8BBD9,
      'productCount': 0,
      'tags': ['wedding', 'dress', 'bride', 'special', 'ceremony'],
    },
    {
      'name': 'Women Shoes',
      'description': 'Trendy and comfortable shoes for women',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WomensShoes2.json',
      'color': 0xFF8BC34A,
      'productCount': 0,
      'tags': ['shoes', 'women', 'footwear', 'fashion', 'comfort'],
    },
    {
      'name': 'Fashion Collection',
      'description': 'Curated fashion items and trendy clothing',
      'icon': null,
      'imageUrl': 'https://i.pinimg.com/736x/f2/e3/9c/f2e39cb60ea8f6eadc90aa5fc913fc58.jpg',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/RC.json',
      'color': 0xFF9C27B0,
      'productCount': 0,
      'tags': ['fashion', 'trendy', 'clothing', 'style', 'collection'],
    },
    {
      'name': 'Women Clothes',
      'description': 'Wide variety of women\'s clothing and accessories',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WomenClothesShuffle.json',
      'color': 0xFFE91E63,
      'productCount': 0,
      'tags': ['women', 'clothes', 'fashion', 'accessories', 'style'],
    },
    {
      'name': 'Toys & Games',
      'description': 'Entertaining toys and games for all ages',
      'icon': null,
      'imageUrl': 'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=400&h=300&fit=crop',
      'jsonUrl': 'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/RCtoyyyyyyyyyyyyyyyyy.json',
      'color': 0xFFFF9800,
      'productCount': 0,
      'tags': ['toys', 'games', 'entertainment', 'fun', 'hobby'],
    },
  ];

  /// Get category by name
  static Map<String, dynamic>? getCategoryByName(String name) {
    try {
      return allCategories.firstWhere((category) => category['name'] == name);
    } catch (e) {
      return null;
    }
  }

  /// Get category by JSON URL
  static Map<String, dynamic>? getCategoryByJsonUrl(String jsonUrl) {
    try {
      return allCategories.firstWhere((category) => category['jsonUrl'] == jsonUrl);
    } catch (e) {
      return null;
    }
  }

  /// Get all category names
  static List<String> getAllCategoryNames() {
    return allCategories.map((category) => category['name'] as String).toList();
  }

  /// Get all JSON URLs
  static List<String> getAllJsonUrls() {
    return allCategories.map((category) => category['jsonUrl'] as String).toList();
  }

  /// Get categories by tag
  static List<Map<String, dynamic>> getCategoriesByTag(String tag) {
    return allCategories.where((category) {
      final tags = category['tags'] as List<dynamic>;
      return tags.any((t) => t.toString().toLowerCase().contains(tag.toLowerCase()));
    }).toList();
  }

  /// Get categories with high commission rates (for affiliate marketing)
  static List<Map<String, dynamic>> getHighCommissionCategories() {
    return allCategories.where((category) {
      // You can customize this logic based on your needs
      return category['name'] == 'Drones & RC' || 
             category['name'] == 'Smartphones' ||
             category['name'] == 'Phone Cases';
    }).toList();
  }

  /// Get categories by price range (estimated)
  static List<Map<String, dynamic>> getCategoriesByPriceRange(String range) {
    switch (range.toLowerCase()) {
      case 'budget':
        return ['Kids Toys', 'Phone Cases', 'Toys & Games']
            .map((name) => getCategoryByName(name)!)
            .toList();
      case 'mid':
        return ['Men Jeans', 'Women Shoes', 'Evening Dresses']
            .map((name) => getCategoryByName(name)!)
            .toList();
      case 'premium':
        return ['Drones & RC', 'Smartphones', 'Wedding Dresses']
            .map((name) => getCategoryByName(name)!)
            .toList();
      default:
        return allCategories;
    }
  }

  /// Get category statistics
  static Map<String, dynamic> getCategoryStats() {
    return {
      'total_categories': allCategories.length,
      'tech_categories': getCategoriesByTag('tech').length,
      'fashion_categories': getCategoriesByTag('fashion').length,
      'toy_categories': getCategoriesByTag('toy').length,
      'dress_categories': getCategoriesByTag('dress').length,
    };
  }

  /// Update product count for a category
  static void updateProductCount(String categoryName, int count) {
    final categoryIndex = allCategories.indexWhere((cat) => cat['name'] == categoryName);
    if (categoryIndex != -1) {
      allCategories[categoryIndex]['productCount'] = count;
    }
  }

  /// Get categories sorted by popularity (product count)
  static List<Map<String, dynamic>> getCategoriesByPopularity() {
    final sorted = List<Map<String, dynamic>>.from(allCategories);
    sorted.sort((a, b) => (b['productCount'] ?? 0).compareTo(a['productCount'] ?? 0));
    return sorted;
  }

  /// Get featured categories (for homepage)
  static List<Map<String, dynamic>> getFeaturedCategories() {
    return ['Drones & RC', 'Evening Dresses', 'Smartphones', 'Wedding Dresses']
        .map((name) => getCategoryByName(name)!)
        .toList();
  }

  /// Get new arrivals categories
  static List<Map<String, dynamic>> getNewArrivalsCategories() {
    return ['Phone Cases', 'Plus Size Clothes', 'Kids Toys', 'Women Shoes']
        .map((name) => getCategoryByName(name)!)
        .toList();
  }
}
