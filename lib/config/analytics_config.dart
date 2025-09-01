class AnalyticsConfig {
  // ========================================
  // GOOGLE ANALYTICS CONFIGURATION
  // ========================================

  /// Your Google Analytics Measurement ID (G-XXXXXXXXXX)
  /// Get this from: https://analytics.google.com/
  static const String measurementId = 'G-VXF219J1RY'; // ✅ Tu Measurement ID

  /// Enable/disable Google Analytics
  static const bool enabled = true;

  /// Enable debug mode for development
  static const bool debugMode = false;

  /// Track page views automatically
  static const bool trackPageViews = true;

  /// Track user interactions automatically
  static const bool trackUserInteractions = true;

  /// Track search queries
  static const bool trackSearch = true;

  /// Track product interactions
  static const bool trackProducts = true;

  /// Track favorites
  static const bool trackFavorites = true;

  /// Track affiliate clicks
  static const bool trackAffiliateClicks = true;

  /// Track app downloads
  static const bool trackAppDownloads = true;

  /// Custom dimensions for advanced tracking
  static const Map<String, String> customDimensions = {
    'user_type': 'cd1',
    'screen_type': 'cd2',
    'category': 'cd3',
    'product_id': 'cd4',
  };

  /// Custom metrics for advanced tracking
  static const Map<String, String> customMetrics = {
    'search_results': 'cm1',
    'favorites_count': 'cm2',
    'session_duration': 'cm3',
  };

  /// Events to track automatically
  static const List<String> autoTrackEvents = [
    'page_view',
    'user_engagement',
    'search',
    'product_interaction',
    'favorites',
    'affiliate_click',
    'app_download',
  ];

  /// Pages to exclude from tracking
  static const List<String> excludedPages = [
    '/admin',
    '/private',
    '/test',
  ];

  /// User properties to set
  static const Map<String, String> userProperties = {
    'app_version': '1.0.0',
    'platform': 'web',
    'language': 'en',
  };

  /// Enhanced ecommerce settings
  static const bool enableEnhancedEcommerce = true;

  /// Demographics and interests reporting
  static const bool enableDemographics = true;

  /// Remarketing features
  static const bool enableRemarketing = true;

  /// IP anonymization (GDPR compliance)
  static const bool anonymizeIp = true;

  /// Session timeout (in seconds)
  static const int sessionTimeout = 1800; // 30 minutes

  /// Campaign timeout (in days)
  static const int campaignTimeout = 6;

  /// Referral timeout (in days)
  static const int referralTimeout = 6;

  /// Content grouping
  static const Map<String, String> contentGroups = {
    'home': 'Home Page',
    'products': 'Product Pages',
    'search': 'Search Results',
    'favorites': 'Favorites',
    'categories': 'Category Pages',
  };

  /// Content experiments
  static const bool enableExperiments = false;

  /// User ID tracking
  static const bool enableUserIdTracking = false;

  /// Exception tracking
  static const bool enableExceptionTracking = true;

  /// Performance tracking
  static const bool enablePerformanceTracking = true;

  /// Real-time reporting
  static const bool enableRealTimeReporting = true;

  /// Enhanced link attribution
  static const bool enableEnhancedLinkAttribution = true;

  /// Cross-domain tracking
  static const List<String> crossDomainTracking = [
    // Add your domains here if you have multiple domains
    // 'example.com',
    // 'subdomain.example.com',
  ];

  /// Debug configuration
  static Map<String, dynamic> get debugConfig => {
        'enabled': debugMode,
        'measurementId': measurementId,
        'trackingFeatures': {
          'pageViews': trackPageViews,
          'userInteractions': trackUserInteractions,
          'search': trackSearch,
          'products': trackProducts,
          'favorites': trackFavorites,
          'affiliateClicks': trackAffiliateClicks,
          'appDownloads': trackAppDownloads,
        },
        'customDimensions': customDimensions,
        'customMetrics': customMetrics,
        'autoTrackEvents': autoTrackEvents,
        'excludedPages': excludedPages,
        'userProperties': userProperties,
      };
}
