import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'responsive_layout.dart';

enum AlertType { success, error, warning, info }

class AlertBar {
  static void show({
    required BuildContext context,
    required String message,
    AlertType type = AlertType.info,
    Duration duration = const Duration(seconds: 3),
    bool showCloseButton = true,
  }) {
    // For web, use SnackBar
    if (ResponsiveLayout.isWeb(context)) {
      _showWebAlert(context, message, type, duration);
    } else {
      // For mobile, use custom overlay
      _showMobileAlert(context, message, type, duration, showCloseButton);
    }
  }

  static void showSuccess({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: AlertType.success,
      duration: duration,
    );
  }

  static void showError({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context: context,
      message: message,
      type: AlertType.error,
      duration: duration,
    );
  }

  static void showWarning({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: AlertType.warning,
      duration: duration,
    );
  }

  static void showInfo({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: AlertType.info,
      duration: duration,
    );
  }

  static void _showWebAlert(
    BuildContext context,
    String message,
    AlertType type,
    Duration duration,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(_getIcon(type), color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: _getColor(type),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  static void _showMobileAlert(
    BuildContext context,
    String message,
    AlertType type,
    Duration duration,
    bool showCloseButton,
  ) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry; // 👈 declare first

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: _getGradient(type),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(_getIcon(type), color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (showCloseButton) ...[
                  const SizedBox(width: 12),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {
                      overlayEntry.remove(); // ✅ now safe
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // Auto dismiss
    Future.delayed(duration, () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }

  // static void _showMobileAlert(
  //   BuildContext context,
  //   String message,
  //   AlertType type,
  //   Duration duration,
  //   bool showCloseButton,
  // ) {
  //   final overlay = Overlay.of(context);
  //   final overlayEntry = OverlayEntry(
  //     builder: (context) => Positioned(
  //       top: MediaQuery.of(context).padding.top + 10,
  //       left: 20,
  //       right: 20,
  //       child: Material(
  //         color: Colors.transparent,
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             gradient: _getGradient(type),
  //             borderRadius: BorderRadius.circular(16),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.2),
  //                 blurRadius: 20,
  //                 spreadRadius: 2,
  //               ),
  //             ],
  //           ),
  //           child: Row(
  //             children: [
  //               Icon(
  //                 _getIcon(type),
  //                 color: Colors.white,
  //                 size: 24,
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: Text(
  //                   message,
  //                   style: const TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                   maxLines: 3,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //               ),
  //               if (showCloseButton) ...[
  //                 const SizedBox(width: 12),
  //                 IconButton(
  //                   icon: const Icon(Icons.close, color: Colors.white, size: 20),
  //                   onPressed: () {
  //                     overlayEntry.remove();
  //                   },
  //                 ),
  //               ],
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );

  //   overlay.insert(overlayEntry);

  //   // Auto remove after duration
  //   Future.delayed(duration, () {
  //     if (overlayEntry.mounted) {
  //       overlayEntry.remove();
  //     }
  //   });
  // }

  static IconData _getIcon(AlertType type) {
    switch (type) {
      case AlertType.success:
        return Icons.check_circle;
      case AlertType.error:
        return Icons.error;
      case AlertType.warning:
        return Icons.warning;
      case AlertType.info:
        return Icons.info;
    }
  }

  static Color _getColor(AlertType type) {
    switch (type) {
      case AlertType.success:
        return AppColors.successColor;
      case AlertType.error:
        return AppColors.errorColor;
      case AlertType.warning:
        return AppColors.warningColor;
      case AlertType.info:
        return AppColors.infoColor;
    }
  }

  static LinearGradient _getGradient(AlertType type) {
    switch (type) {
      case AlertType.success:
        return AppColors.successGradient;
      case AlertType.error:
        return LinearGradient(
          colors: [AppColors.errorColor, Color(0xFFD32F2F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case AlertType.warning:
        return LinearGradient(
          colors: [AppColors.warningColor, Color(0xFFFFB74D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case AlertType.info:
        return LinearGradient(
          colors: [AppColors.infoColor, Color(0xFF64B5F6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }
}
