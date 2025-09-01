import 'dart:html' as html;
import 'package:flutter/foundation.dart';

class WebUrlService {
  /// Opens a URL in a new tab for web platforms
  static Future<bool> openUrlInNewTab(String url) async {
    try {
      if (kIsWeb) {
        // For web, use window.open
        final Uri uri = Uri.parse(url);
        if (uri.isAbsolute) {
          // Open in new tab with affiliate tracking
          html.window.open(url, '_blank');
          return true;
        } else {
          throw Exception('Invalid URL format: $url');
        }
      } else {
        // For non-web platforms, this won't work
        throw Exception('This service is only available on web platforms');
      }
    } catch (e) {
      print('Error opening URL in new tab: $e');
      return false;
    }
  }

  /// Opens a URL in the same tab
  static Future<bool> openUrlInSameTab(String url) async {
    try {
      if (kIsWeb) {
        final Uri uri = Uri.parse(url);
        if (uri.isAbsolute) {
          html.window.location.href = url;
          return true;
        } else {
          throw Exception('Invalid URL format: $url');
        }
      } else {
        throw Exception('This service is only available on web platforms');
      }
    } catch (e) {
      print('Error opening URL in same tab: $e');
      return false;
    }
  }

  /// Checks if a URL is valid
  static bool isValidUrl(String url) {
    try {
      final Uri uri = Uri.parse(url);
      return uri.isAbsolute;
    } catch (e) {
      return false;
    }
  }

  /// Gets the current URL
  static String getCurrentUrl() {
    if (kIsWeb) {
      return html.window.location.href;
    }
    return '';
  }

  /// Gets the current domain
  static String getCurrentDomain() {
    if (kIsWeb) {
      return html.window.location.hostname ?? '';
    }
    return '';
  }
}
