import 'package:flutter/widgets.dart';

class Dimensions {
  // Padding
  static const double paddingExtraSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingDefault = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraLarge = 32.0;

  // Margin
  static const double marginExtraSmall = 4.0;
  static const double marginSmall = 8.0;
  static const double marginDefault = 16.0;
  static const double marginLarge = 24.0;
  static const double marginExtraLarge = 32.0;

  // Radius
  static const double radiusSmall = 6.0;
  static const double radiusDefault = 12.0;
  static const double radiusLarge = 20.0;
  static const double radiusExtraLarge = 30.0;
  static const double radiusRound = 50.0;

  // Font Size
  static const double fontSizeExtraSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeDefault = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeExtraLarge = 24.0;
  static const double fontSizeHeading = 28.0;

  // Icon Size
  static const double iconSizeSmall = 16.0;
  static const double iconSizeDefault = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeExtraLarge = 48.0;

  // Button
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightDefault = 50.0;
  static const double buttonHeightLarge = 60.0;

  // App Bar
  static const double appBarHeight = 56.0;
  static const double appBarElevation = 4.0;

  // Image
  static const double imageSizeSmall = 40.0;
  static const double imageSizeDefault = 80.0;
  static const double imageSizeLarge = 120.0;
  static const double imageSizeExtraLarge = 200.0;

  // Responsive Breakpoints
  static const double mobileWidth = 600.0;
  static const double tabletWidth = 900.0;
  static const double desktopWidth = 1200.0;

  // Get responsive padding based on screen width
  static double getResponsivePadding(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) {
      return paddingExtraLarge;
    } else if (width >= tabletWidth) {
      return paddingLarge;
    } else {
      return paddingDefault;
    }
  }

  // Get responsive font size
  static double getResponsiveFontSize(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    if (width >= desktopWidth) {
      return fontSizeMedium;
    } else if (width >= tabletWidth) {
      return fontSizeDefault;
    } else {
      return fontSizeSmall;
    }
  }
}
