import 'package:flutter/material.dart';
import '../models/category_model.dart';

class AppConstants {
  // ========================================
  // APP INFORMATION
  // ========================================
  static const String appName = 'China Prices';
  static const String appVersion = '1.0.0';

  // ========================================
  // WEB RESPONSIVE BREAKPOINTS
  // ========================================
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 900.0;
  static const double desktopBreakpoint = 1200.0;

  // ========================================
  // WEB-SPECIFIC CONSTANTS
  // ========================================
  static const String webAppTitle =
      'China Prices - Compare Prices Across Chinese E-commerce';
  static const String webAppDescription =
      'Your ultimate shopping companion for the best deals from Chinese e-commerce platforms';
  static const String webAppKeywords =
      'china prices, shopping, e-commerce, price comparison, aliexpress, taobao, jd';

  // ========================================
  // COLORS - PRIMARY PALETTE
  // ========================================
  static const Color primaryColor = Color(0xFFFF6B35);
  static const Color secondaryColor = Color(0xFF4ECDC4);
  static const Color accentColor = Color(0xFFFFB347);

  // ========================================
  // COLORS - BACKGROUND & SURFACE
  // ========================================
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;

  // ========================================
  // COLORS - TEXT
  // ========================================
  static const Color textPrimaryColor = Color(0xFF2C3E50);
  static const Color textSecondaryColor = Color(0xFF7F8C8D);
  static const Color textLightColor = Color(0xFFBDC3C7);

  // ========================================
  // COLORS - STATUS & FEEDBACK
  // ========================================
  static const Color successColor = Color(0xFF27AE60);
  static const Color errorColor = Color(0xFFE74C3C);
  static const Color warningColor = Color(0xFFF39C12);
  static const Color infoColor = Color(0xFF3498DB);

  // ========================================
  // COLORS - GRADIENTS
  // ========================================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, secondaryColor],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [backgroundColor, Color(0xFFE8E8E8)],
  );

  // ========================================
  // WEB ADVERTISING (Replace with your web ad IDs)
  // ========================================
  static const String googleAdSenseId = 'ca-pub-XXXXXXXXXXXXXXXX';

  // ========================================
  // GOOGLE ANALYTICS (Replace with your Measurement ID)
  // ========================================
  static const String googleAnalyticsId =
      'G-VXF219J1RY'; // ✅ Tu Measurement ID de Google Analytics
  static const bool enableGoogleAnalytics =
      true; // ✅ Activar/desactivar Analytics

  // ========================================
  // STORE URLs & AFFILIATE LINKS
  // ========================================
  static const Map<String, String> storeUrls = {
    'AliExpress': 'https://www.aliexpress.com',
    'Taobao': 'https://www.taobao.com',
    'JD.com': 'https://www.jd.com',
    'DHgate': 'https://www.dhgate.com',
    'Pinduoduo': 'https://www.pinduoduo.com',
    'VIP.com': 'https://www.vip.com',
    'Tmall': 'https://www.tmall.com',
  };

  // ========================================
  // EDITABLE CATEGORIES - FULLY CUSTOMIZABLE
  // ========================================
  //
  // HOW TO EDIT CATEGORIES:
  // =======================
  // 1. Change the 'name' to whatever you want (e.g., 'Electronics' -> 'Wigs' or 'Cars')
  // 2. Set 'icon' to null if you want to show only the image (no icon)
  // 3. Set 'imageUrl' to null if you want to show only the icon (no image)
  // 4. Change 'jsonUrl' to point to your category's JSON file
  // 5. Add 'color' for custom colors (optional)
  //
  // EXAMPLES:
  // - To show only image: set 'icon' to null
  // - To show only icon: set 'imageUrl' to null
  // - To change Electronics to Wigs: change 'name': 'Electronics' to 'name': 'Wigs'
  // - To use custom color: add 'color': 0xFFE91E63 (pink)
  //
  // ICON CODES: Use Material Icons code points (e.g., 0xe3e4 for Icons.devices)
  // Find icons at: https://fonts.google.com/icons
  static const List<Map<String, dynamic>> editableCategories = [
    {
      'name': 'Drones & RC',
      'icon': null, // Icons.flight
      'imageUrl':
          'https://images.unsplash.com/photo-1579829366248-204fe8413f31?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/Drone.json',
      'color': 0xFF2196F3, // Blue color for drones
    },
    {
      'name': 'Evening Dresses',
      'icon': null, // Icons.dress
      'imageUrl':
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/EveningDress.json',
      'color': 0xFFE91E63, // Pink color for dresses
    },
    {
      'name': 'Phone Cases',
      'icon': null, // Icons.phone_android
      'imageUrl':
          'https://images.unsplash.com/photo-1603313011108-4f2d0c0c5c1c?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/phonecases2.json',
      'color': 0xFF9C27B0, // Purple color for tech
    },
    {
      'name': 'Men Jeans',
      'icon': null, // Icons.man
      'imageUrl':
          'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/menjeans200.json',
      'color': 0xFF795548, // Brown color for jeans
    },
    {
      'name': 'Plus Size Clothes',
      'icon': null, // Icons.accessibility
      'imageUrl':
          'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/plussizeclothes1.json',
      'color': 0xFFFF9800, // Orange color for fashion
    },
    {
      'name': 'Electronics',
      'icon': null, // Icons.devices
      'imageUrl':
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/smartphone5.json',
      'color': 0xFF607D8B, // Blue-grey color for electronics
    },
    {
      'name': 'Smartphones',
      'icon': null, // Icons.phone_iphone
      'imageUrl':
          'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/smartphone1.json',
      'color': 0xFF607D8B, // Blue-grey color for phones
    },
    {
      'name': 'Plus Size Dresses',
      'icon': null, // Icons.dress
      'imageUrl':
          'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/womenplussizedresses.json',
      'color': 0xFFE91E63, // Pink color for dresses
    },
    {
      'name': 'Kids Toys',
      'icon': null, // Icons.toys
      'imageUrl':
          'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/Kidstoysshufles2.json',
      'color': 0xFFFF5722, // Deep orange for kids
    },
    {
      'name': 'Wedding Dresses',
      'icon': null, // Icons.favorite
      'imageUrl':
          'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WeddingDresses.json',
      'color': 0xFFF8BBD9, // Light pink for wedding
    },
    {
      'name': 'Women Shoes',
      'icon': null, // Icons.sports_soccer
      'imageUrl':
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WomensShoes2.json',
      'color': 0xFF8BC34A, // Light green for shoes
    },
    {
      'name': 'Fashion Collection',
      'icon': null, // Icons.style
      'imageUrl':
          'https://i.pinimg.com/736x/f2/e3/9c/f2e39cb60ea8f6eadc90aa5fc913fc58.jpg',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/RC.json',
      'color': 0xFF9C27B0, // Purple for fashion
    },
    {
      'name': 'Women Clothes',
      'icon': null, // Icons.woman
      'imageUrl':
          'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WomenClothesShuffle.json',
      'color': 0xFFE91E63, // Pink for women's fashion
    },
    {
      'name': 'Toys & Games',
      'icon': null, // Icons.toys
      'imageUrl':
          'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=400&h=300&fit=crop',
      'jsonUrl':
          'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/RCtoyyyyyyyyyyyyyyyyy.json',
      'color': 0xFFFF9800, // Orange for toys
    },
  ];

  // ========================================
  // CATEGORY JSON LINKS - GITHUB (LEGACY - DEPRECATED)
  // ========================================
  static const Map<String, String> categoryJsonLinks = {
    'Drones & RC':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/Drone.json',
    'Evening Dresses':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/EveningDress.json',
    'Phone Cases':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/phonecases2.json',
    'Men Jeans':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/menjeans200.json',
    'Plus Size Clothes':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/plussizeclothes1.json',
    'Smartphones':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/smartphone1.json',
    'Plus Size Dresses':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/womenplussizedresses.json',
    'Kids Toys':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/Kidstoysshufles2.json',
    'Wedding Dresses':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WeddingDresses.json',
    'Women Shoes':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WomensShoes2.json',
    'Fashion Collection':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/RC.json',
    'Women Clothes':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/WomenClothesShuffle.json',
    'Toys & Games':
        'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/RCtoyyyyyyyyyyyyyyyyy.json',
  };

  // ========================================
  // FASHION JSON LINK - GITHUB
  // ========================================
  static const String fashionJsonUrl =
      'https://raw.githubusercontent.com/anasgermany/Anas/refs/heads/master/high_quality_images.json';

  // ========================================
  // APP STORE LINKS - ANDROID ONLY
  // ========================================
  static const String googlePlayStoreUrl =
      'https://play.google.com/store/apps/details?id=com.chinashopping.onlinechinashopping.chinaonlineshopping.china.online.shopping.chinashoppingonline';

  // App promotion text for sharing - Android only
  static const String appPromotionText =
      'Check out this amazing fashion item! Discover more styles in China Shopping Online app - your ultimate shopping companion for the best deals from Chinese e-commerce platforms! 📱✨\n\nDownload now:\nAndroid: $googlePlayStoreUrl';

  // ========================================
  // CATEGORY IMAGES URLs (LEGACY - DEPRECATED)
  // ========================================
  static const Map<String, String> categoryImages = {
    'Drones & RC':
        'https://images.unsplash.com/photo-1579829366248-204fe8413f31?w=400&h=300&fit=crop',
    'Evening Dresses':
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=300&fit=crop',
    'Phone Cases':
        'https://images.unsplash.com/photo-1603313011108-4f2d0c0c5c1c?w=400&h=300&fit=crop',
    'Men Jeans':
        'https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=300&fit=crop',
    'Plus Size Clothes':
        'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&h=300&fit=crop',
    'Smartphones':
        'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=300&fit=crop',
    'Plus Size Dresses':
        'https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=300&fit=crop',
    'Kids Toys':
        'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=400&h=300&fit=crop',
    'Wedding Dresses':
        'https://images.unsplash.com/photo-1519741497674-611481863552?w=400&h=300&fit=crop',
    'Women Shoes':
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=300&fit=crop',
    'Fashion Collection':
        'https://i.pinimg.com/736x/f2/e3/9c/f2e39cb60ea8f6eadc90aa5fc913fc58.jpg',
    'Women Clothes':
        'https://images.unsplash.com/photo-1445205170230-053b83016050?w=400&h=300&fit=crop',
    'Toys & Games':
        'https://images.unsplash.com/photo-1566576912321-d58ddd7a6088?w=400&h=300&fit=crop',
  };

  // ========================================
  // HELPER METHODS FOR CATEGORIES
  // ========================================

  /// Get all editable categories as CategoryModel objects
  static List<CategoryModel> getEditableCategories() {
    return editableCategories.map((categoryData) {
      return CategoryModel(
        name: categoryData['name'] ?? '',
        icon: categoryData['icon'] != null
            ? IconData(categoryData['icon'], fontFamily: 'MaterialIcons')
            : null,
        imageUrl: categoryData['imageUrl'],
        jsonUrl: categoryData['jsonUrl'] ?? '',
        color:
            categoryData['color'] != null ? Color(categoryData['color']) : null,
      );
    }).toList();
  }

  /// Get JSON URL for a specific category
  static String getCategoryJsonUrl(String categoryName) {
    final category = editableCategories.firstWhere(
      (cat) => cat['name'] == categoryName,
      orElse: () => {'jsonUrl': ''},
    );
    return category['jsonUrl'] ?? '';
  }

  /// Get all category names
  static List<String> getCategoryNames() {
    return editableCategories.map((cat) => cat['name'] as String).toList();
  }

  // ========================================
  // SHARED PREFERENCES KEYS
  // ========================================
  static const String favoritesKey = 'favorites';
  static const String searchHistoryKey = 'search_history';
  static const String adCountKey = 'ad_count';
  static const String searchCountKey = 'search_count';
  static const String lastSearchKey = 'last_search';
  static const String userPreferencesKey = 'user_preferences';

  // ========================================
  // UI CONSTANTS - DIMENSIONS
  // ========================================
  static const double borderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultMargin = 16.0;
  static const double smallMargin = 8.0;
  static const double largeMargin = 24.0;

  // ========================================
  // UI CONSTANTS - SIZES
  // ========================================
  static const double iconSize = 24.0;
  static const double smallIconSize = 16.0;
  static const double largeIconSize = 32.0;

  static const double buttonHeight = 56.0;
  static const double smallButtonHeight = 40.0;
  static const double largeButtonHeight = 64.0;

  static const double cardElevation = 4.0;
  static const double smallCardElevation = 2.0;
  static const double largeCardElevation = 8.0;

  // ========================================
  // SEARCH & DATA CONSTANTS
  // ========================================
  static const int maxSearchHistory = 10;
  static const int maxFavorites = 100;
  static const int searchCountForAd = 5;
  static const int searchDebounceMs = 500;
  static const int maxSearchResults = 50;
  static const int maxCategoryProducts = 100;

  // ========================================
  // ANIMATION DURATIONS
  // ========================================
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);
  static const Duration verySlowAnimation = Duration(milliseconds: 800);

  // Legacy animation names for backward compatibility
  static const Duration shortAnimation = fastAnimation;
  static const Duration mediumAnimation = normalAnimation;
  static const Duration longAnimation = slowAnimation;

  // ========================================
  // STORE COLORS & ICONS
  // ========================================
  static const Map<String, Color> storeColors = {
    'AliExpress': Color(0xFFFF4747),
    'Taobao': Color(0xFFFF6B35),
    'JD.com': Color(0xFFE74C3C),
    'DHgate': Color(0xFF3498DB),
    'Pinduoduo': Color(0xFFFF6B6B),
    'VIP.com': Color(0xFF9B59B6),
    'Tmall': Color(0xFFFF8E53),
  };

  static const Map<String, IconData> storeIcons = {
    'AliExpress': Icons.shopping_cart,
    'Taobao': Icons.store,
    'JD.com': Icons.shopping_bag,
    'DHgate': Icons.business,
    'Pinduoduo': Icons.local_mall,
    'VIP.com': Icons.card_giftcard,
    'Tmall': Icons.storefront,
  };

  // ========================================
  // APP DESCRIPTION
  // ========================================
  static const String appDescription =
      'Compare prices across Chinese e-commerce platforms';

  // ========================================
  // SPLASH SCREEN CONFIGURATION
  // ========================================
  static const String splashBackgroundImageUrl =
      'https://images.unsplash.com/photo-1441986300917-64674bd600d8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80';

  // ========================================
  // AD CONFIGURATION
  // ========================================
  static const int bannerAdHeight = 250;
  static const int nativeAdHeight = 320;
  static const int interstitialAdFrequency = 5;
  static const bool enableTestAds = true;
  static const bool enableProductionAds = false;

  // Interstitial Ad IDs
  static const String splashScreenInterstitialId =
      'ca-app-pub-3940256099942544/1033173712'; // Test ad ID
  static const String appInterstitialId =
      'ca-app-pub-3940256099942544/1033173712'; // Test ad ID for app clicks

  // Interstitial Ad Configuration
  static const int clicksBeforeInterstitial =
      5; // Show interstitial after 5 clicks

  // ========================================
  // NETWORK & API CONSTANTS
  // ========================================
  static const int connectionTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds

  // ========================================
  // ERROR MESSAGES
  // ========================================
  static const String networkErrorMessage =
      'Network error. Please check your connection.';
  static const String generalErrorMessage =
      'Something went wrong. Please try again.';
  static const String noResultsMessage =
      'No products found. Try a different search.';
  static const String loadingMessage = 'Loading...';
  static const String errorLoadingProducts = 'Error loading products';
  static const String errorUpdatingFavorites = 'Error updating favorites';

  // ========================================
  // SUCCESS MESSAGES
  // ========================================
  static const String addedToFavorites = 'Added to favorites';
  static const String removedFromFavorites = 'Removed from favorites';
  static const String productsShuffled = 'Products shuffled!';
  static const String searchCleared = 'Search history cleared';
  static const String favoritesCleared = 'Favorites cleared';

  // ========================================
  // VALIDATION CONSTANTS
  // ========================================
  static const int minSearchLength = 2;
  static const int maxSearchLength = 100;
  static const int maxProductTitleLength = 200;
  static const int maxProductDescriptionLength = 1000;

  // ========================================
  // SETTINGS & CONTACT CONSTANTS
  // ========================================
  static const String supportEmail = 'support@chinaprices.com';
  static const String companyEmail = 'info@chinaprices.com';
  static const String privacyPolicyUrl =
      'https://chinaprices.com/privacy-policy';
  static const String termsOfServiceUrl =
      'https://chinaprices.com/terms-of-service';
  static const String appStoreUrl =
      'https://play.google.com/store/apps/details?id=com.chinashopping.onlinechinashopping.chinaonlineshopping.china.online.shopping.chinashoppingonline';

  // Email Configuration
  static const String emailSubjectPrefix = '[ChinaPrices]';
  static const String emailSubjectDefault = 'App Support Request';
  static const String emailBodyTemplate =
      'Hello,\n\nI would like to contact you regarding the China Prices app.\n\nApp Version: 1.0.0\nDevice: Android\n\nBest regards,\n[Your Name]';

  // Automatic Notification Configuration
  static const int automaticNotificationIntervalSeconds = 0; // Seconds (0-59)
  static const int automaticNotificationIntervalMinutes = 0; // Minutes (0-59)
  static const int automaticNotificationIntervalHours = 1; // Hours (0-23)
  static const bool enableAutomaticNotifications =
      true; // Set to false to disable automatic notifications

  // Settings Colors
  static const Color settingsPrimaryColor = Color(0xFF3338A0);
  static const Color settingsSecondaryColor = Color(0xFF8B5CF6);
  static const Color settingsAccentColor = Color(0xFF06B6D4);
  static const Color settingsBackgroundColor = Color(0xFFF8FAFC);
  static const Color settingsCardColor = Color(0xFFFFFFFF);
  static const Color settingsTextColor = Color(0xFF1E293B);
  static const Color settingsSubtextColor = Color(0xFF64748B);

  // Settings Text
  static const String settingsTitle = 'Settings';
  static const String contactUsTitle = 'Contact Us';
  static const String contactUsSubtitle = 'We\'d love to hear from you';
  static const String sendEmailText = 'Send us an email';
  static const String privacyPolicyText = 'Privacy Policy';
  static const String termsOfServiceText = 'Terms of Service';
  static const String rateAppText = 'Rate our app';
  static const String rateAppSubtitle = 'Help us with 5 stars!';
  static const String appVersionText = 'App Version';
  static const String aboutAppText = 'About China Prices';
  static const String aboutAppDescription =
      'Your ultimate shopping companion for the best deals from Chinese e-commerce platforms';
}
