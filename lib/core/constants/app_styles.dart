import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'dimensions.dart';

class AppStyles {
  // Text Styles
  static TextStyle get headline1 => TextStyle(
    fontSize: Dimensions.fontSizeExtraLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle get headline2 => TextStyle(
    fontSize: Dimensions.fontSizeLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static TextStyle get headline3 => TextStyle(
    fontSize: Dimensions.fontSizeMedium,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle get headline4 => TextStyle(
    fontSize: Dimensions.fontSizeDefault,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  static TextStyle get bodyText1 => TextStyle(
    fontSize: Dimensions.fontSizeDefault,
    fontWeight: FontWeight.normal,
    color: AppColors.darkGrey,
  );

  static TextStyle get bodyText2 => TextStyle(
    fontSize: Dimensions.fontSizeSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );

  static TextStyle get caption => TextStyle(
    fontSize: Dimensions.fontSizeExtraSmall,
    fontWeight: FontWeight.normal,
    color: AppColors.grey,
  );

  static TextStyle get button => TextStyle(
    fontSize: Dimensions.fontSizeDefault,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  // Input Decoration
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Dimensions.paddingDefault,
      vertical: Dimensions.paddingSmall,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      borderSide: BorderSide(color: AppColors.lightGrey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      borderSide: BorderSide(color: AppColors.lightGrey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      borderSide: BorderSide(color: AppColors.errorColor),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      borderSide: BorderSide(color: AppColors.errorColor, width: 2),
    ),
    labelStyle: TextStyle(color: AppColors.darkGrey),
    hintStyle: TextStyle(color: AppColors.grey),
    errorStyle: TextStyle(color: AppColors.errorColor),
  );

  // Card Style
  static BoxDecoration get cardDecoration => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        spreadRadius: 2,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Button Style
  static ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(
      horizontal: Dimensions.paddingLarge,
      vertical: Dimensions.paddingDefault,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
    ),
    elevation: 4,
    textStyle: button,
  );

  static ButtonStyle get secondaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.primaryColor,
    padding: EdgeInsets.symmetric(
      horizontal: Dimensions.paddingLarge,
      vertical: Dimensions.paddingDefault,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
      side: BorderSide(color: AppColors.primaryColor),
    ),
    elevation: 0,
    textStyle: button.copyWith(color: AppColors.primaryColor),
  );

  // App Bar Style
  static AppBarTheme get appBarTheme => AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    elevation: 4,
    centerTitle: true,
    titleTextStyle: headline3.copyWith(color: Colors.white),
  );
}
