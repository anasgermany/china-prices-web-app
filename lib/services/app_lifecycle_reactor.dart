import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_open_ad_manager.dart';

/// Listens for app foreground events and shows app open ads.
class AppLifecycleReactor {
  final AppOpenAdManager appOpenAdManager;
  bool _isListening = false;
  bool _shouldShowAd = false;

  AppLifecycleReactor({required this.appOpenAdManager});

  void listenToAppStateChanges() {
    if (_isListening) return;
    
    _shouldShowAd = true;
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
    _isListening = true;
  }

  void _onAppStateChanged(AppState appState) {
    // Only show ad if flag is set and app is coming to foreground
    if (appState == AppState.foreground && _shouldShowAd) {
      print('App came to foreground, showing app open ad if available');
      appOpenAdManager.showAdIfAvailable();
      _shouldShowAd = false; // Reset flag after showing ad
    }
  }

  void dispose() {
    if (_isListening) {
      AppStateEventNotifier.stopListening();
      _isListening = false;
    }
  }
}
