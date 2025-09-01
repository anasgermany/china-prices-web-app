import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class ResponsiveUtils {
  /// Get the current screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    
    if (width < AppConstants.mobileBreakpoint) {
      return ScreenSize.mobile;
    } else if (width < AppConstants.tabletBreakpoint) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return getScreenSize(context) == ScreenSize.mobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return getScreenSize(context) == ScreenSize.tablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return getScreenSize(context) == ScreenSize.desktop;
  }

  /// Get responsive grid cross axis count
  static int getGridCrossAxisCount(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return 2;
      case ScreenSize.tablet:
        return 3;
      case ScreenSize.desktop:
        return 4;
    }
  }

  /// Get responsive padding
  static EdgeInsets getResponsivePadding(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(16.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(24.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32.0);
    }
  }

  /// Get responsive margin
  static EdgeInsets getResponsiveMargin(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(8.0);
      case ScreenSize.tablet:
        return const EdgeInsets.all(16.0);
      case ScreenSize.desktop:
        return const EdgeInsets.all(24.0);
    }
  }

  /// Get responsive font size
  static double getResponsiveFontSize(BuildContext context, {
    required double mobile,
    required double tablet,
    required double desktop,
  }) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet;
      case ScreenSize.desktop:
        return desktop;
    }
  }

  /// Get responsive icon size
  static double getResponsiveIconSize(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return 24.0;
      case ScreenSize.tablet:
        return 28.0;
      case ScreenSize.desktop:
        return 32.0;
    }
  }

  /// Get responsive button height
  static double getResponsiveButtonHeight(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return 48.0;
      case ScreenSize.tablet:
        return 56.0;
      case ScreenSize.desktop:
        return 64.0;
    }
  }

  /// Get responsive card elevation
  static double getResponsiveCardElevation(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return 2.0;
      case ScreenSize.tablet:
        return 4.0;
      case ScreenSize.desktop:
        return 8.0;
    }
  }

  /// Get responsive border radius
  static double getResponsiveBorderRadius(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return 8.0;
      case ScreenSize.tablet:
        return 12.0;
      case ScreenSize.desktop:
        return 16.0;
    }
  }

  /// Get responsive spacing between elements
  static double getResponsiveSpacing(BuildContext context) {
    switch (getScreenSize(context)) {
      case ScreenSize.mobile:
        return 8.0;
      case ScreenSize.tablet:
        return 16.0;
      case ScreenSize.desktop:
        return 24.0;
    }
  }
}

enum ScreenSize {
  mobile,
  tablet,
  desktop,
}
