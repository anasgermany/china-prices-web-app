import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'constants/app_constants.dart';
import 'routes.dart';
import 'services/app_provider_web.dart';
import 'services/analytics_service.dart';
import 'config/analytics_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Analytics if enabled
  if (AnalyticsConfig.enabled && AnalyticsConfig.measurementId.isNotEmpty) {
    try {
      await AnalyticsService.initialize(AnalyticsConfig.measurementId);
      print(
          '✅ Google Analytics initialized with ID: ${AnalyticsConfig.measurementId}');

      if (AnalyticsConfig.debugMode) {
        print('🔍 Analytics Debug Config: ${AnalyticsConfig.debugConfig}');
      }
    } catch (e) {
      print('❌ Error initializing Google Analytics in main(): $e');
    }
  } else {
    print('⚠️ Google Analytics not configured or disabled');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: MaterialApp(
        title: AppConstants.webAppTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppConstants.primaryColor,
            brightness: Brightness.light,
          ),
          primaryColor: AppConstants.primaryColor,
          scaffoldBackgroundColor: AppConstants.backgroundColor,
          appBarTheme: AppBarTheme(
            backgroundColor: AppConstants.primaryColor,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
