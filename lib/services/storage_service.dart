import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product_model.dart';
import '../models/navigation_history_model.dart';
import '../models/gamification_model.dart';

class StorageService {
  static const String _favoritesKey = 'favorites';
  static const String _searchHistoryKey = 'search_history';
  static const String _adCountKey = 'ad_count';
  static const String _navigationHistoryKey = 'navigation_history';
  static const String _challengesKey = 'challenges';
  static const String _badgesKey = 'badges';
  static const String _userPointsKey = 'user_points';
  static const String _referralSystemKey = 'referral_system';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Favorites methods
  Future<void> addToFavorites(Product product) async {
    try {
      print('StorageService: Adding product to favorites: ${product.productDesc} (ID: ${product.productId})');
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();
      
      print('StorageService: Current favorites count: ${favorites.length}');
      
      // Check if product is already in favorites
      final exists = favorites.any((p) => p.productId == product.productId);
      if (!exists) {
        favorites.add(product);
        final favoritesJson = favorites.map((p) => p.toJson()).toList();
        final jsonString = jsonEncode(favoritesJson);
        print('StorageService: JSON string length: ${jsonString.length}');
        await prefs.setString(_favoritesKey, jsonString);
        print('StorageService: Product successfully added to favorites. New count: ${favorites.length}');
        
        // Verify the save was successful
        final savedFavorites = await getFavorites();
        print('StorageService: Verification - saved favorites count: ${savedFavorites.length}');
      } else {
        print('StorageService: Product already exists in favorites');
      }
    } catch (e) {
      print('StorageService: Error adding to favorites: $e');
      print('StorageService: Error stack trace: ${StackTrace.current}');
    }
  }

  Future<void> removeFromFavorites(int productId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favorites = await getFavorites();
      
      favorites.removeWhere((product) => product.productId == productId);
      final favoritesJson = favorites.map((p) => p.toJson()).toList();
      await prefs.setString(_favoritesKey, jsonEncode(favoritesJson));
      print('Product removed from favorites: $productId');
    } catch (e) {
      print('Error removing from favorites: $e');
    }
  }

  Future<List<Product>> getFavorites() async {
    try {
      print('StorageService: Getting favorites...');
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString(_favoritesKey);
      
      print('StorageService: Raw favorites string length: ${favoritesString?.length ?? 0}');
      if (favoritesString != null && favoritesString.isNotEmpty) {
        print('StorageService: Raw favorites string preview: ${favoritesString.substring(0, favoritesString.length > 100 ? 100 : favoritesString.length)}...');
      }
      
      if (favoritesString != null && favoritesString.isNotEmpty) {
        try {
          final List<dynamic> favoritesJson = jsonDecode(favoritesString);
          print('StorageService: Successfully decoded JSON, found ${favoritesJson.length} items');
          
          final favorites = favoritesJson.map((json) {
            try {
              return Product.fromJson(json);
            } catch (e) {
              print('StorageService: Error parsing product from JSON: $e');
              print('StorageService: Problematic JSON: $json');
              return null;
            }
          }).where((product) => product != null).cast<Product>().toList();
          
          print('StorageService: Successfully loaded ${favorites.length} favorites');
          return favorites;
        } catch (jsonError) {
          print('StorageService: Error decoding JSON: $jsonError');
          print('StorageService: Problematic string: $favoritesString');
          return [];
        }
      } else {
        print('StorageService: No favorites found in storage');
      }
    } catch (e) {
      print('StorageService: Error loading favorites: $e');
      print('StorageService: Error stack trace: ${StackTrace.current}');
    }
    return [];
  }

  Future<bool> isFavorite(int productId) async {
    try {
      final favorites = await getFavorites();
      return favorites.any((product) => product.productId == productId);
    } catch (e) {
      print('Error checking favorite status: $e');
      return false;
    }
  }

  // Search history methods
  Future<void> addToSearchHistory(String query) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final history = await getSearchHistory();
      
      // Remove if already exists and add to front
      history.remove(query);
      history.insert(0, query);
      
      // Keep only last 10 searches
      if (history.length > 10) {
        history.removeRange(10, history.length);
      }
      
      await prefs.setStringList(_searchHistoryKey, history);
    } catch (e) {
      print('Error adding to search history: $e');
    }
  }

  Future<List<String>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_searchHistoryKey) ?? [];
    } catch (e) {
      print('Error loading search history: $e');
      return [];
    }
  }

  Future<void> clearSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_searchHistoryKey);
    } catch (e) {
      print('Error clearing search history: $e');
    }
  }

  // Ad count methods
  Future<void> incrementAdCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt(_adCountKey) ?? 0;
      await prefs.setInt(_adCountKey, currentCount + 1);
    } catch (e) {
      print('Error incrementing ad count: $e');
    }
  }

  Future<int> getAdCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_adCountKey) ?? 0;
    } catch (e) {
      print('Error getting ad count: $e');
      return 0;
    }
  }

  Future<void> resetAdCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_adCountKey, 0);
    } catch (e) {
      print('Error resetting ad count: $e');
    }
  }

  // Navigation History Methods
  Future<void> addToNavigationHistory(Product product, String category) async {
    try {
      print('StorageService: Adding product to navigation history: ${product.productDesc}');
      final prefs = await SharedPreferences.getInstance();
      final history = await getNavigationHistory();
      
      // Check if product already exists in history
      final existingIndex = history.indexWhere((h) => h.productId == product.productId);
      
      if (existingIndex != -1) {
        // Update existing entry
        final existing = history[existingIndex];
        history[existingIndex] = existing.copyWith(
          viewCount: existing.viewCount + 1,
          viewedAt: DateTime.now(),
        );
      } else {
        // Add new entry
        history.add(NavigationHistory(
          productId: product.productId.toString(),
          productName: product.productDesc,
          imageUrl: product.imageUrl,
          category: category,
          viewedAt: DateTime.now(),
        ));
      }
      
      // Sort by most recent
      history.sort((a, b) => b.viewedAt.compareTo(a.viewedAt));
      
      // Keep only last 50 items
      if (history.length > 50) {
        history.removeRange(50, history.length);
      }
      
      final historyJson = history.map((h) => h.toJson()).toList();
      await prefs.setString(_navigationHistoryKey, jsonEncode(historyJson));
      print('StorageService: Navigation history updated. Total items: ${history.length}');
    } catch (e) {
      print('StorageService: Error adding to navigation history: $e');
    }
  }

  Future<List<NavigationHistory>> getNavigationHistory() async {
    try {
      print('StorageService: Getting navigation history...');
      final prefs = await SharedPreferences.getInstance();
      final historyString = prefs.getString(_navigationHistoryKey);
      
      if (historyString != null && historyString.isNotEmpty) {
        final List<dynamic> historyJson = jsonDecode(historyString);
        final history = historyJson.map((json) => NavigationHistory.fromJson(json)).toList();
        print('StorageService: Loaded ${history.length} navigation history items');
        return history;
      }
    } catch (e) {
      print('StorageService: Error loading navigation history: $e');
    }
    return [];
  }

  Future<void> clearNavigationHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_navigationHistoryKey);
      print('StorageService: Navigation history cleared');
    } catch (e) {
      print('StorageService: Error clearing navigation history: $e');
    }
  }

  // Gamification Methods
  Future<void> saveChallenges(List<Challenge> challenges) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final challengesJson = challenges.map((c) => c.toJson()).toList();
      await prefs.setString(_challengesKey, jsonEncode(challengesJson));
      print('StorageService: Saved ${challenges.length} challenges');
    } catch (e) {
      print('StorageService: Error saving challenges: $e');
    }
  }

  Future<List<Challenge>> getChallenges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final challengesString = prefs.getString(_challengesKey);
      if (challengesString != null) {
        final challengesJson = jsonDecode(challengesString) as List<dynamic>;
        final challenges = challengesJson.map((c) => Challenge.fromJson(c)).toList();
        print('StorageService: Loaded ${challenges.length} challenges');
        return challenges;
      }
    } catch (e) {
      print('StorageService: Error loading challenges: $e');
    }
    return [];
  }

  Future<void> saveBadges(List<GamificationBadge> badges) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final badgesJson = badges.map((b) => b.toJson()).toList();
      await prefs.setString(_badgesKey, jsonEncode(badgesJson));
      print('StorageService: Saved ${badges.length} badges');
    } catch (e) {
      print('StorageService: Error saving badges: $e');
    }
  }

  Future<List<GamificationBadge>> getBadges() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final badgesString = prefs.getString(_badgesKey);
      if (badgesString != null) {
        final badgesJson = jsonDecode(badgesString) as List<dynamic>;
        final badges = badgesJson.map((b) => GamificationBadge.fromJson(b)).toList();
        print('StorageService: Loaded ${badges.length} badges');
        return badges;
      }
    } catch (e) {
      print('StorageService: Error loading badges: $e');
    }
    return [];
  }

  Future<void> saveUserPoints(UserPoints userPoints) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userPointsKey, jsonEncode(userPoints.toJson()));
      print('StorageService: Saved user points - Level ${userPoints.level}, Points: ${userPoints.currentPoints}');
    } catch (e) {
      print('StorageService: Error saving user points: $e');
    }
  }

  Future<UserPoints> getUserPoints() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final pointsString = prefs.getString(_userPointsKey);
      if (pointsString != null) {
        final pointsJson = jsonDecode(pointsString);
        final userPoints = UserPoints.fromJson(pointsJson);
        print('StorageService: Loaded user points - Level ${userPoints.level}, Points: ${userPoints.currentPoints}');
        return userPoints;
      }
    } catch (e) {
      print('StorageService: Error loading user points: $e');
    }
    return UserPoints(
      totalPoints: 0,
      currentPoints: 0,
      level: 1,
      pointsToNextLevel: 100,
      transactions: [],
    );
  }

  Future<void> saveReferralSystem(ReferralSystem referralSystem) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_referralSystemKey, jsonEncode(referralSystem.toJson()));
      print('StorageService: Saved referral system - Code: ${referralSystem.referralCode}, Referrals: ${referralSystem.totalReferrals}');
    } catch (e) {
      print('StorageService: Error saving referral system: $e');
    }
  }

  Future<ReferralSystem> getReferralSystem() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final referralString = prefs.getString(_referralSystemKey);
      if (referralString != null) {
        final referralJson = jsonDecode(referralString);
        final referralSystem = ReferralSystem.fromJson(referralJson);
        print('StorageService: Loaded referral system - Code: ${referralSystem.referralCode}');
        return referralSystem;
      }
    } catch (e) {
      print('StorageService: Error loading referral system: $e');
    }
    return ReferralSystem(
      referralCode: _generateReferralCode(),
      referrals: [],
      createdAt: DateTime.now(),
    );
  }

  String _generateReferralCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return String.fromCharCodes(
      Iterable.generate(8, (_) => chars.codeUnitAt(random.nextInt(chars.length))),
    );
  }
}
