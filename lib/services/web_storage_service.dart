import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class WebStorageService {
  static const String _favoritesKey = 'favorites';
  static const String _searchHistoryKey = 'search_history';
  static const String _navigationHistoryKey = 'navigation_history';
  static const String _userPreferencesKey = 'user_preferences';
  static const String _userPointsKey = 'user_points';
  static const String _challengesKey = 'challenges';
  static const String _badgesKey = 'badges';
  static const String _referralSystemKey = 'referral_system';

  // Generic storage methods
  Future<bool> saveData(String key, String value) async {
    try {
      if (kIsWeb) {
        html.window.localStorage[key] = value;
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(key, value);
      }
      return true;
    } catch (e) {
      print('Error saving data: $e');
      return false;
    }
  }

  Future<String?> getData(String key) async {
    try {
      if (kIsWeb) {
        return html.window.localStorage[key];
      } else {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getString(key);
      }
    } catch (e) {
      print('Error getting data: $e');
      return null;
    }
  }

  Future<bool> removeData(String key) async {
    try {
      if (kIsWeb) {
        html.window.localStorage.remove(key);
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(key);
      }
      return true;
    } catch (e) {
      print('Error removing data: $e');
      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      if (kIsWeb) {
        html.window.localStorage.clear();
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();
      }
      return true;
    } catch (e) {
      print('Error clearing data: $e');
      return false;
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      if (kIsWeb) {
        return html.window.localStorage.containsKey(key);
      } else {
        final prefs = await SharedPreferences.getInstance();
        return prefs.containsKey(key);
      }
    } catch (e) {
      print('Error checking key: $e');
      return false;
    }
  }

  Future<Set<String>> getKeys() async {
    try {
      if (kIsWeb) {
        return html.window.localStorage.keys.toSet();
      } else {
        final prefs = await SharedPreferences.getInstance();
        return prefs.getKeys();
      }
    } catch (e) {
      print('Error getting keys: $e');
      return <String>{};
    }
  }

  // ========================================
  // FAVORITES MANAGEMENT
  // ========================================
  Future<bool> addToFavorites(String productId) async {
    try {
      final favorites = await getFavorites();
      if (!favorites.contains(productId)) {
        favorites.add(productId);
        final jsonValue = jsonEncode(favorites);
        return await saveData(_favoritesKey, jsonValue);
      }
      return true;
    } catch (e) {
      print('Error adding to favorites: $e');
      return false;
    }
  }

  Future<bool> removeFromFavorites(String productId) async {
    try {
      final favorites = await getFavorites();
      favorites.remove(productId);
      final jsonValue = jsonEncode(favorites);
      return await saveData(_favoritesKey, jsonValue);
    } catch (e) {
      print('Error removing from favorites: $e');
      return false;
    }
  }

  Future<List<String>> getFavorites() async {
    try {
      final data = await getData(_favoritesKey);
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((item) => item.toString()).toList();
      }
      return <String>[];
    } catch (e) {
      print('Error getting favorites: $e');
      return <String>[];
    }
  }

  Future<bool> isFavorite(String productId) async {
    try {
      final favorites = await getFavorites();
      return favorites.contains(productId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // ========================================
  // SEARCH HISTORY MANAGEMENT
  // ========================================
  Future<bool> addToSearchHistory(String searchTerm) async {
    try {
      final history = await getSearchHistory();
      if (!history.contains(searchTerm)) {
        history.insert(0, searchTerm);
        // Keep only last 20 searches
        if (history.length > 20) {
          history.removeRange(20, history.length);
        }
        final jsonValue = jsonEncode(history);
        return await saveData(_searchHistoryKey, jsonValue);
      }
      return true;
    } catch (e) {
      print('Error adding to search history: $e');
      return false;
    }
  }

  Future<List<String>> getSearchHistory() async {
    try {
      final data = await getData(_searchHistoryKey);
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((item) => item.toString()).toList();
      }
      return <String>[];
    } catch (e) {
      print('Error getting search history: $e');
      return <String>[];
    }
  }

  Future<bool> clearSearchHistory() async {
    try {
      return await removeData(_searchHistoryKey);
    } catch (e) {
      print('Error clearing search history: $e');
      return false;
    }
  }

  // ========================================
  // NAVIGATION HISTORY MANAGEMENT
  // ========================================
  Future<bool> addToNavigationHistory(String route, String title, {Map<String, dynamic>? data}) async {
    try {
      final history = await getNavigationHistory();
      final newEntry = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'route': route,
        'title': title,
        'data': data ?? {},
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      history.insert(0, newEntry);
      // Keep only last 50 entries
      if (history.length > 50) {
        history.removeRange(50, history.length);
      }
      
      final jsonValue = jsonEncode(history);
      return await saveData(_navigationHistoryKey, jsonValue);
    } catch (e) {
      print('Error adding to navigation history: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getNavigationHistory() async {
    try {
      final data = await getData(_navigationHistoryKey);
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return <Map<String, dynamic>>[];
    } catch (e) {
      print('Error getting navigation history: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<bool> clearNavigationHistory() async {
    try {
      return await removeData(_navigationHistoryKey);
    } catch (e) {
      print('Error clearing navigation history: $e');
      return false;
    }
  }

  // ========================================
  // USER PREFERENCES
  // ========================================
  Future<bool> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final jsonValue = jsonEncode(preferences);
      return await saveData(_userPreferencesKey, jsonValue);
    } catch (e) {
      print('Error saving user preferences: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getUserPreferences() async {
    try {
      final data = await getData(_userPreferencesKey);
      if (data != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(data);
        return jsonMap;
      }
      return <String, dynamic>{};
    } catch (e) {
      print('Error getting user preferences: $e');
      return <String, dynamic>{};
    }
  }

  // ========================================
  // GAMIFICATION DATA
  // ========================================
  Future<bool> saveUserPoints(int points) async {
    try {
      return await saveData(_userPointsKey, points.toString());
    } catch (e) {
      print('Error saving user points: $e');
      return false;
    }
  }

  Future<int> getUserPoints() async {
    try {
      final data = await getData(_userPointsKey);
      if (data != null) {
        return int.tryParse(data) ?? 0;
      }
      return 0;
    } catch (e) {
      print('Error getting user points: $e');
      return 0;
    }
  }

  Future<bool> saveChallenges(List<Map<String, dynamic>> challenges) async {
    try {
      final jsonValue = jsonEncode(challenges);
      return await saveData(_challengesKey, jsonValue);
    } catch (e) {
      print('Error saving challenges: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getChallenges() async {
    try {
      final data = await getData(_challengesKey);
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return <Map<String, dynamic>>[];
    } catch (e) {
      print('Error getting challenges: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<bool> saveBadges(List<Map<String, dynamic>> badges) async {
    try {
      final jsonValue = jsonEncode(badges);
      return await saveData(_badgesKey, jsonValue);
    } catch (e) {
      print('Error saving badges: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getBadges() async {
    try {
      final data = await getData(_badgesKey);
      if (data != null) {
        final List<dynamic> jsonList = jsonDecode(data);
        return jsonList.map((item) => Map<String, dynamic>.from(item)).toList();
      }
      return <Map<String, dynamic>>[];
    } catch (e) {
      print('Error getting badges: $e');
      return <Map<String, dynamic>>[];
    }
  }

  Future<bool> saveReferralSystem(Map<String, dynamic> referralSystem) async {
    try {
      final jsonValue = jsonEncode(referralSystem);
      return await saveData(_referralSystemKey, jsonValue);
    } catch (e) {
      print('Error saving referral system: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getReferralSystem() async {
    try {
      final data = await getData(_referralSystemKey);
      if (data != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(data);
        return jsonMap;
      }
      return <String, dynamic>{};
    } catch (e) {
      print('Error getting referral system: $e');
      return <String, dynamic>{};
    }
  }
}
