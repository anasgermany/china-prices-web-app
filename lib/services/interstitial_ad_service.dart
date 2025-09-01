import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class InterstitialAdService {
  static final InterstitialAdService _instance = InterstitialAdService._internal();
  factory InterstitialAdService() => _instance;
  InterstitialAdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;
  int _clickCount = 0;
  bool _isLoading = false;

  // Initialize the service
  Future<void> initialize() async {
    await _loadClickCount();
    await _loadInterstitialAd();
  }

  // Load click count from storage
  Future<void> _loadClickCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _clickCount = prefs.getInt('app_click_count') ?? 0;
      print('InterstitialAdService: Loaded click count: $_clickCount');
    } catch (e) {
      print('InterstitialAdService: Error loading click count: $e');
      _clickCount = 0;
    }
  }

  // Save click count to storage
  Future<void> _saveClickCount() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('app_click_count', _clickCount);
      print('InterstitialAdService: Saved click count: $_clickCount');
    } catch (e) {
      print('InterstitialAdService: Error saving click count: $e');
    }
  }

  // Load interstitial ad
  Future<void> _loadInterstitialAd() async {
    if (_isLoading) return;
    
    _isLoading = true;
    try {
      await InterstitialAd.load(
        adUnitId: AppConstants.appInterstitialId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _isAdLoaded = true;
            _isLoading = false;
            print('InterstitialAdService: App interstitial ad loaded successfully');
          },
          onAdFailedToLoad: (error) {
            print('InterstitialAdService: App interstitial ad failed to load: $error');
            _isAdLoaded = false;
            _isLoading = false;
          },
        ),
      );
    } catch (e) {
      print('InterstitialAdService: Error loading app interstitial ad: $e');
      _isAdLoaded = false;
      _isLoading = false;
    }
  }

  // Track app click and show ad if needed
  Future<void> trackAppClick() async {
    _clickCount++;
    await _saveClickCount();
    
    print('InterstitialAdService: App click tracked. Count: $_clickCount');
    
    // Check if we should show the interstitial ad
    if (_clickCount >= AppConstants.clicksBeforeInterstitial) {
      await _showInterstitialAd();
      _clickCount = 0; // Reset counter after showing ad
      await _saveClickCount();
    }
  }

  // Show interstitial ad
  Future<void> _showInterstitialAd() async {
    if (_interstitialAd != null && _isAdLoaded) {
      try {
        // Set up callbacks before showing the ad
        _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (ad) {
            print('InterstitialAdService: App interstitial ad dismissed');
            ad.dispose();
            _isAdLoaded = false;
            // Load a new ad for next time
            _loadInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (ad, error) {
            print('InterstitialAdService: App interstitial ad failed to show: $error');
            ad.dispose();
            _isAdLoaded = false;
            // Load a new ad for next time
            _loadInterstitialAd();
          },
          onAdShowedFullScreenContent: (ad) {
            print('InterstitialAdService: App interstitial ad showed full screen content');
          },
        );
        
        await _interstitialAd!.show();
        print('InterstitialAdService: App interstitial ad show() called successfully');
      } catch (e) {
        print('InterstitialAdService: Error showing app interstitial ad: $e');
        _isAdLoaded = false;
        // Load a new ad for next time
        _loadInterstitialAd();
      }
    } else {
      print('InterstitialAdService: App interstitial ad not ready to show');
      // Try to load a new ad
      _loadInterstitialAd();
    }
  }

  // Get current click count (for debugging)
  int get clickCount => _clickCount;

  // Reset click count (for testing)
  Future<void> resetClickCount() async {
    _clickCount = 0;
    await _saveClickCount();
    print('InterstitialAdService: Click count reset to 0');
  }

  // Dispose resources
  void dispose() {
    _interstitialAd?.dispose();
  }
}
