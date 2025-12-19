import 'package:flutter/material.dart';
import '../constants/dimensions.dart';

class ResponsiveLayout {
  // Screen size detection
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < Dimensions.mobileWidth;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= Dimensions.mobileWidth && width < Dimensions.tabletWidth;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= Dimensions.tabletWidth;
  }

  static bool isWeb(BuildContext context) {
    return MediaQuery.of(context).size.width >= Dimensions.desktopWidth;
  }

  // Responsive value based on screen size - 3 parameters version
  static T responsiveValue<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    return desktop;
  }

  // Responsive value based on screen size - 4 parameters version (with web)
  static T responsiveValueWithWeb<T>(
    BuildContext context, {
    required T mobile,
    required T tablet,
    required T desktop,
    required T web,
  }) {
    if (isMobile(context)) return mobile;
    if (isTablet(context)) return tablet;
    if (isWeb(context)) return web;
    return desktop;
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsiveValue(
        context,
        mobile: Dimensions.paddingDefault,
        tablet: Dimensions.paddingLarge,
        desktop: Dimensions.paddingExtraLarge,
      ),
      vertical: responsiveValue(
        context,
        mobile: Dimensions.paddingSmall,
        tablet: Dimensions.paddingDefault,
        desktop: Dimensions.paddingLarge,
      ),
    );
  }

  // Responsive padding with web
  static EdgeInsets responsivePaddingWithWeb(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: responsiveValueWithWeb(
        context,
        mobile: Dimensions.paddingDefault,
        tablet: Dimensions.paddingLarge,
        desktop: Dimensions.paddingExtraLarge,
        web: Dimensions.paddingExtraLarge * 1.5,
      ),
      vertical: responsiveValueWithWeb(
        context,
        mobile: Dimensions.paddingSmall,
        tablet: Dimensions.paddingDefault,
        desktop: Dimensions.paddingLarge,
        web: Dimensions.paddingExtraLarge,
      ),
    );
  }

  // Responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return EdgeInsets.all(
      responsiveValue(
        context,
        mobile: Dimensions.marginSmall,
        tablet: Dimensions.marginDefault,
        desktop: Dimensions.marginLarge,
      ),
    );
  }

  // Grid layout columns
  static int gridColumns(BuildContext context) {
    return responsiveValueWithWeb(
      context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
      web: 4,
    );
  }

  // Aspect ratio for images
  static double imageAspectRatio(BuildContext context) {
    return responsiveValueWithWeb(
      context,
      mobile: 16 / 9,
      tablet: 3 / 2,
      desktop: 4 / 3,
      web: 16 / 9,
    );
  }

  // Font size scaling
  static double responsiveFontSize(BuildContext context, double baseSize) {
    double scale = responsiveValueWithWeb(
      context,
      mobile: 1.0,
      tablet: 1.1,
      desktop: 1.2,
      web: 1.3,
    );
    return baseSize * scale;
  }

  // Sidebar width
  static double sidebarWidth(BuildContext context) {
    return responsiveValueWithWeb(
      context,
      mobile: MediaQuery.of(context).size.width * 0.7,
      tablet: MediaQuery.of(context).size.width * 0.4,
      desktop: 280,
      web: 320,
    );
  }

  // Get current screen type as string
  static String screenType(BuildContext context) {
    if (isMobile(context)) return 'mobile';
    if (isTablet(context)) return 'tablet';
    if (isWeb(context)) return 'web';
    return 'desktop';
  }

  // Check if screen is extra large
  static bool isExtraLarge(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1600;
  }

  // Get safe area padding
  static EdgeInsets safeAreaPadding(BuildContext context) {
    return EdgeInsets.only(
      top: MediaQuery.of(context).padding.top,
      bottom: MediaQuery.of(context).padding.bottom,
      left: responsiveValueWithWeb(
        context,
        mobile: MediaQuery.of(context).padding.left,
        tablet: MediaQuery.of(context).padding.left * 2,
        desktop: MediaQuery.of(context).padding.left * 3,
        web: MediaQuery.of(context).padding.left * 4,
      ),
      right: responsiveValueWithWeb(
        context,
        mobile: MediaQuery.of(context).padding.right,
        tablet: MediaQuery.of(context).padding.right * 2,
        desktop: MediaQuery.of(context).padding.right * 3,
        web: MediaQuery.of(context).padding.right * 4,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import '../constants/dimensions.dart';

// class ResponsiveLayout {
//   // Screen size detection
//   static bool isMobile(BuildContext context) {
//     return MediaQuery.of(context).size.width < Dimensions.mobileWidth;
//   }

//   static bool isTablet(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return width >= Dimensions.mobileWidth && width < Dimensions.tabletWidth;
//   }

//   static bool isDesktop(BuildContext context) {
//     return MediaQuery.of(context).size.width >= Dimensions.tabletWidth;
//   }

//   static bool isWeb(BuildContext context) {
//     return MediaQuery.of(context).size.width >= Dimensions.desktopWidth;
//   }

//   // Responsive value based on screen size
//   static T responsiveValue<T>(
//     BuildContext context, {
//     required T mobile,
//     required T tablet,
//     required T desktop,
//   }) {
//     if (isMobile(context)) return mobile;
//     if (isTablet(context)) return tablet;
//     return desktop;
//   }

//   // Responsive padding
//   static EdgeInsets responsivePadding(BuildContext context) {
//     return EdgeInsets.symmetric(
//       horizontal: responsiveValue(
//         context,
//         mobile: Dimensions.paddingDefault,
//         tablet: Dimensions.paddingLarge,
//         desktop: Dimensions.paddingExtraLarge,
//       ),
//       vertical: responsiveValue(
//         context,
//         mobile: Dimensions.paddingSmall,
//         tablet: Dimensions.paddingDefault,
//         desktop: Dimensions.paddingLarge,
//       ),
//     );
//   }

//   // Responsive margin
//   static EdgeInsets responsiveMargin(BuildContext context) {
//     return EdgeInsets.all(
//       responsiveValue(
//         context,
//         mobile: Dimensions.marginSmall,
//         tablet: Dimensions.marginDefault,
//         desktop: Dimensions.marginLarge,
//       ),
//     );
//   }

//   // Grid layout columns
//   static int gridColumns(BuildContext context) {
//     return responsiveValue(
//       context,
//       mobile: 1,
//       tablet: 2,
//       desktop: 3,
//     );
//   }

//   // Aspect ratio for images
//   static double imageAspectRatio(BuildContext context) {
//     return responsiveValue(
//       context,
//       mobile: 16 / 9,
//       tablet: 3 / 2,
//       desktop: 4 / 3,
//     );
//   }

//   // Font size scaling
//   static double responsiveFontSize(BuildContext context, double baseSize) {
//     double scale = responsiveValue(
//       context,
//       mobile: 1.0,
//       tablet: 1.1,
//       desktop: 1.2,
//     );
//     return baseSize * scale;
//   }

//   // Sidebar width
//   static double sidebarWidth(BuildContext context) {
//     return responsiveValue(
//       context,
//       mobile: MediaQuery.of(context).size.width * 0.7,
//       tablet: MediaQuery.of(context).size.width * 0.4,
//       desktop: 280,
//     );
//   }
// }
