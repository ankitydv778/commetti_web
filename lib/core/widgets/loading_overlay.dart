import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/dimensions.dart';
import '../utils/responsive_layout.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final String? message;
  final Color? overlayColor;
  final Color? indicatorColor;
  final double? indicatorSize;
  final bool dismissible;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.child,
    this.message,
    this.overlayColor,
    this.indicatorColor,
    this.indicatorSize,
    this.dismissible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          ModalBarrier(
            color: overlayColor ?? Colors.black.withOpacity(0.5),
            dismissible: dismissible,
          ),
        if (isLoading)
          Center(
            child: Container(
              padding: EdgeInsets.all(
                ResponsiveLayout.isWeb(context)
                    ? Dimensions.paddingLarge
                    : Dimensions.paddingDefault,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: indicatorSize ?? 40,
                    height: indicatorSize ?? 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        indicatorColor ?? AppColors.primaryColor,
                      ),
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: Dimensions.paddingDefault),
                    Text(
                      message!,
                      style: const TextStyle(
                        fontSize: Dimensions.fontSizeDefault,
                        color: AppColors.darkGrey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// Full Screen Loader
class FullScreenLoader extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;
  final bool showLogo;

  const FullScreenLoader({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
    this.showLogo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLogo) ...[
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 40,
                  color: AppColors.primaryColor,
                ),
              ),
              const SizedBox(height: Dimensions.paddingLarge),
            ],
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  indicatorColor ?? AppColors.primaryColor,
                ),
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: Dimensions.paddingDefault),
              Text(
                message!,
                style: const TextStyle(
                  fontSize: Dimensions.fontSizeDefault,
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// Shimmer Loading
class ShimmerLoading extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    this.width,
    this.height,
    this.borderRadius = Dimensions.radiusDefault,
    this.baseColor,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor ?? AppColors.lightGrey,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// List Shimmer Loading
class ListShimmerLoading extends StatelessWidget {
  final int itemCount;
  final bool hasLeading;
  final bool hasTrailing;

  const ListShimmerLoading({
    super.key,
    this.itemCount = 5,
    this.hasLeading = true,
    this.hasTrailing = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: const EdgeInsets.all(Dimensions.paddingDefault),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: Dimensions.paddingDefault),
          padding: const EdgeInsets.all(Dimensions.paddingDefault),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              if (hasLeading)
                ShimmerLoading(
                  width: 50,
                  height: 50,
                  borderRadius: Dimensions.radiusRound,
                ),
              if (hasLeading) const SizedBox(width: Dimensions.paddingDefault),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerLoading(
                      height: 16,
                      borderRadius: Dimensions.radiusSmall,
                    ),
                    const SizedBox(height: 8),
                    ShimmerLoading(
                      height: 12,
                      width: 200,
                      borderRadius: Dimensions.radiusSmall,
                    ),
                  ],
                ),
              ),
              if (hasTrailing) const SizedBox(width: Dimensions.paddingDefault),
              if (hasTrailing)
                ShimmerLoading(
                  width: 40,
                  height: 40,
                  borderRadius: Dimensions.radiusDefault,
                ),
            ],
          ),
        );
      },
    );
  }
}
