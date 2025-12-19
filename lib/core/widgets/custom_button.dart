import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/dimensions.dart';
import '../utils/responsive_layout.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Widget? icon;
  final bool isFullWidth;
  final bool disabled;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.backgroundColor = AppColors.primaryColor,
    this.foregroundColor = Colors.white,
    this.borderColor,
    this.width,
    this.height,
    this.borderRadius = Dimensions.radiusDefault,
    this.padding,
    this.textStyle,
    this.icon,
    this.isFullWidth = false,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);
    final responsiveHeight = ResponsiveLayout.responsiveValue(
      context,
      mobile: Dimensions.buttonHeightDefault,
      tablet: Dimensions.buttonHeightDefault,
      desktop: Dimensions.buttonHeightLarge,
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : width ?? (isWeb ? 200 : null),
      height: height ?? responsiveHeight,
      child: ElevatedButton(
        onPressed: (disabled || isLoading) ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: disabled ? AppColors.grey : backgroundColor,
          foregroundColor: foregroundColor,
          padding:
              padding ??
              EdgeInsets.symmetric(
                horizontal: isWeb
                    ? Dimensions.paddingLarge
                    : Dimensions.paddingDefault,
                vertical: isWeb
                    ? Dimensions.paddingDefault
                    : Dimensions.paddingSmall,
              ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            side: borderColor != null
                ? BorderSide(color: borderColor!)
                : BorderSide.none,
          ),
          elevation: isWeb ? 4 : 2,
          shadowColor: backgroundColor.withOpacity(0.3),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[icon!, const SizedBox(width: 8)],
                  Flexible(
                    child: Text(
                      text,
                      style:
                          textStyle ??
                          TextStyle(
                            fontSize: isWeb
                                ? Dimensions.fontSizeMedium
                                : Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600,
                          ),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// Gradient Button
class GradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final Gradient? gradient;
  final double borderRadius;
  final EdgeInsets? padding;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.gradient,
    this.borderRadius = Dimensions.radiusDefault,
    this.padding,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style:
                    textStyle ??
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}

// Outline Button
class OutlineCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color borderColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets? padding;

  const OutlineCustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.borderColor = AppColors.primaryColor,
    this.textColor = AppColors.primaryColor,
    this.borderRadius = Dimensions.radiusDefault,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: borderColor, width: 1.5),
        foregroundColor: textColor,
        padding:
            padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: Colors.transparent,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

// Icon Button
class IconCustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double borderRadius;
  final String? tooltip;

  const IconCustomButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.backgroundColor = AppColors.primaryColor,
    this.iconColor = Colors.white,
    this.size = 40,
    this.borderRadius = Dimensions.radiusDefault,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip ?? '',
      child: Material(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            width: size,
            height: size,
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: size * 0.6),
          ),
        ),
      ),
    );
  }
}
