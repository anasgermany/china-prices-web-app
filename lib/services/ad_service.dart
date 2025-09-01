import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';

class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  bool _isInitialized = false;
  AppOpenAd? _appOpenAd;
  InterstitialAd? _interstitialAd;
  BannerAd? _bannerAd;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      await MobileAds.instance.initialize();
      _isInitialized = true;
      
      // Load app open ad
      await _loadAppOpenAd();
    } catch (e) {
      print('Error initializing ads: $e');
    }
  }

  Future<void> _loadAppOpenAd() async {
    try {
      await AppOpenAd.load(
        adUnitId: AppConstants.adMobAppOpenId,
        orientation: AppOpenAd.orientationPortrait,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            _appOpenAd = ad;
            _appOpenAd!.show();
          },
          onAdFailedToLoad: (error) {
            print('App open ad failed to load: $error');
          },
        ),
      );
    } catch (e) {
      print('Error loading app open ad: $e');
    }
  }

  Future<void> loadInterstitialAd() async {
    try {
      await InterstitialAd.load(
        adUnitId: AppConstants.adMobInterstitialId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
                _interstitialAd = null;
              },
              onAdFailedToShowFullScreenContent: (ad, error) {
                ad.dispose();
                _interstitialAd = null;
              },
            );
          },
          onAdFailedToLoad: (error) {
            print('Interstitial ad failed to load: $error');
          },
        ),
      );
    } catch (e) {
      print('Error loading interstitial ad: $e');
    }
  }

  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      await _interstitialAd!.show();
    } else {
      await loadInterstitialAd();
    }
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: AppConstants.adMobBannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Banner ad loaded');
        },
        onAdFailedToLoad: (ad, error) {
          print('Banner ad failed to load: $error');
          ad.dispose();
        },
      ),
    );
  }

  Future<void> dispose() async {
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
    _bannerAd?.dispose();
  }
}
