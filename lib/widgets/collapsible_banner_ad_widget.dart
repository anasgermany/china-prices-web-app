import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io';
import '../constants/app_constants.dart';

class CollapsibleBannerAdWidget extends StatefulWidget {
  const CollapsibleBannerAdWidget({super.key});

  @override
  State<CollapsibleBannerAdWidget> createState() => _CollapsibleBannerAdWidgetState();
}

class _CollapsibleBannerAdWidgetState extends State<CollapsibleBannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = true;
  String? _errorMessage;
  bool _hasLoaded = false;

  @override
  void initState() {
    super.initState();
    // Don't load ad here, wait for didChangeDependencies
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasLoaded) {
      _hasLoaded = true;
      _loadAd();
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _loadAd() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      // Try different test ad units for collapsible banner
      final String adUnitId = Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111' // Try regular banner first
          : 'ca-app-pub-3940256099942544/2934735716';

      print('Loading collapsible banner ad with ID: $adUnitId');

      // Get the adaptive banner size
      final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
          MediaQuery.sizeOf(context).width.truncate());

      if (size == null) {
        print('Unable to get banner size, using default');
        // Fallback to standard banner size
        const fallbackSize = AdSize.banner;
        _createCollapsibleAd(adUnitId, fallbackSize);
        return;
      }

      print('Banner size: ${size.width}x${size.height}');
      _createCollapsibleAd(adUnitId, size);

    } catch (e) {
      print('Error loading collapsible banner ad: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: $e';
        });
      }
    }
  }

  void _createCollapsibleAd(String adUnitId, AdSize size) {
    // Create the collapsible banner ad following Google's official implementation
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: size,
      request: const AdRequest(
        // Create an extra parameter that aligns the bottom of the expanded ad to the
        // bottom of the banner ad.
        extras: {
          "collapsible": "bottom",
        },
      ),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('Collapsible banner ad loaded successfully');
          if (mounted) {
            setState(() {
              _isLoaded = true;
              _isLoading = false;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          print('Collapsible banner ad failed to load: $error');
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Failed to load: ${error.message}';
            });
          }
          ad.dispose();
        },
        onAdOpened: (ad) {
          print('Collapsible banner ad opened');
        },
        onAdClosed: (ad) {
          print('Collapsible banner ad closed');
        },
        onAdImpression: (ad) {
          print('Collapsible banner ad impression');
        },
      ),
    );

    _bannerAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 8),
              Text('Loading Collapsible Ad...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: Center(
          child: Text(
            'Collapsible Ad Error: $_errorMessage',
            style: TextStyle(color: Colors.red[700]),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (!_isLoaded || _bannerAd == null) {
      return Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        ),
        child: const Center(
          child: Text(
            'Collapsible Ad not loaded',
            style: TextStyle(color: Colors.orange),
          ),
        ),
      );
    }

    // Following Google's official implementation for collapsible banner ads
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
