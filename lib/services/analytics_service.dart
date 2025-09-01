import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert';
import 'dart:js' as js;

class AnalyticsService {
  static const String _gtagScript = '''
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
  ''';

  static const String _gtagConfig = '''
    gtag('config', 'MEASUREMENT_ID_PLACEHOLDER', {
      'page_title': document.title,
      'page_location': window.location.href,
      'custom_map': {
        'custom_parameter_1': 'user_type',
        'custom_parameter_2': 'app_version'
      }
    });
  ''';

  static bool _isInitialized = false;
  static String? _measurementId;

  /// Initialize Google Analytics
  static Future<void> initialize(String measurementId) async {
    if (_isInitialized) return;
    
    _measurementId = measurementId;
    
    if (kIsWeb) {
      try {
        // Add gtag script
        final script = html.ScriptElement()
          ..src = 'https://www.googletagmanager.com/gtag/js?id=$measurementId'
          ..async = true;
        
        html.document.head!.append(script);
        
        // Add inline script
        final inlineScript = html.ScriptElement()
          ..text = _gtagScript;
        html.document.head!.append(inlineScript);
        
        // Configure gtag
        final configScript = html.ScriptElement()
          ..text = _gtagConfig.replaceAll('MEASUREMENT_ID_PLACEHOLDER', measurementId);
        html.document.head!.append(configScript);
        
        _isInitialized = true;
        print('✅ Google Analytics initialized successfully with ID: $measurementId');
      } catch (e) {
        print('❌ Error initializing Google Analytics: $e');
      }
    }
  }

  /// Track page view
  static void trackPageView({
    required String pageName,
    String? pageTitle,
    Map<String, dynamic>? parameters,
  }) {
    if (!_isInitialized || !kIsWeb) return;
    
    try {
      final data = {
        'page_title': pageTitle ?? pageName,
        'page_location': html.window.location.href,
        'page_name': pageName,
        ...?parameters,
      };
      
      js.context.callMethod('gtag', ['event', 'page_view', data]);
      print('📊 Analytics: Page view tracked - $pageName');
    } catch (e) {
      print('❌ Error tracking page view: $e');
    }
  }

  /// Track custom events
  static void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    if (!_isInitialized || !kIsWeb) return;
    
    try {
      js.context.callMethod('gtag', ['event', eventName, parameters ?? {}]);
      print('📊 Analytics: Event tracked - $eventName');
    } catch (e) {
      print('❌ Error tracking event: $e');
    }
  }

  /// Track user engagement
  static void trackUserEngagement({
    required String action,
    String? category,
    String? label,
    int? value,
  }) {
    trackEvent(
      eventName: 'user_engagement',
      parameters: {
        'action': action,
        'category': category,
        'label': label,
        'value': value,
      },
    );
  }

  /// Track product interactions
  static void trackProductInteraction({
    required dynamic productId,
    required String action,
    String? productName,
    String? category,
    double? price,
  }) {
    trackEvent(
      eventName: 'product_interaction',
      parameters: {
        'product_id': productId,
        'action': action,
        'product_name': productName,
        'category': category,
        'price': price,
        'currency': 'USD',
      },
    );
  }

  /// Track search queries
  static void trackSearch({
    required String searchTerm,
    int? resultCount,
    String? category,
  }) {
    trackEvent(
      eventName: 'search',
      parameters: {
        'search_term': searchTerm,
        'result_count': resultCount,
        'category': category,
      },
    );
  }

  /// Track favorites
  static void trackFavorites({
    required String action,
    String? productId,
    String? productName,
  }) {
    trackEvent(
      eventName: 'favorites',
      parameters: {
        'action': action,
        'product_id': productId,
        'product_name': productName,
      },
    );
  }

  /// Track affiliate link clicks
  static void trackAffiliateClick({
    required String productId,
    required String productName,
    required String affiliateUrl,
    String? category,
  }) {
    trackEvent(
      eventName: 'affiliate_click',
      parameters: {
        'product_id': productId,
        'product_name': productName,
        'affiliate_url': affiliateUrl,
        'category': category,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track app downloads
  static void trackAppDownload({
    required String platform,
    required String downloadUrl,
  }) {
    trackEvent(
      eventName: 'app_download',
      parameters: {
        'platform': platform,
        'download_url': downloadUrl,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );
  }

  /// Track user demographics (if available)
  static void trackUserDemographics({
    String? country,
    String? language,
    String? deviceType,
    String? browser,
  }) {
    trackEvent(
      eventName: 'user_demographics',
      parameters: {
        'country': country,
        'language': language,
        'device_type': deviceType,
        'browser': browser,
      },
    );
  }

  /// Track performance metrics
  static void trackPerformance({
    required String metricName,
    required double value,
    String? unit,
  }) {
    trackEvent(
      eventName: 'performance',
      parameters: {
        'metric_name': metricName,
        'value': value,
        'unit': unit,
      },
    );
  }

  /// Get current analytics status
  static bool get isInitialized => _isInitialized;
  static String? get measurementId => _measurementId;

  /// Reset analytics (for testing)
  static void reset() {
    _isInitialized = false;
    _measurementId = null;
  }
}
