import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../constants/app_colors.dart';
import '../constants/dimensions.dart';
import '../widgets/custom_button.dart';

enum DialogType { success, error, warning, info, confirmation, custom }

class CustomDialog {
  static Future<bool?> show({
    required BuildContext context,
    required DialogType type,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    Widget? icon,
    Widget? content,
    Color? confirmColor,
    Color? cancelColor,
    bool dismissible = true,
    bool showCloseButton = true,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    double? maxWidth,
  }) async {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return await showModal<bool>(
      context: context,
      configuration: const FadeScaleTransitionConfiguration(
        barrierDismissible: true,
      ),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(40),
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth ?? 500),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingLarge),
                  decoration: BoxDecoration(
                    color: _getHeaderColor(type, isDarkMode),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.radiusLarge),
                      topRight: Radius.circular(Dimensions.radiusLarge),
                    ),
                  ),
                  child: Row(
                    children: [
                      if (icon != null) ...[
                        icon,
                        const SizedBox(width: 12),
                      ] else
                        Icon(
                          _getDialogIcon(type),
                          color: _getIconColor(type),
                          size: 24,
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (showCloseButton && dismissible)
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                    ],
                  ),
                ),

                // Content
                Container(
                  padding: const EdgeInsets.all(Dimensions.paddingLarge),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (content != null)
                        content
                      else
                        Text(
                          message,
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.grey.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const SizedBox(height: Dimensions.paddingLarge),

                      // Actions
                      Row(
                        children: [
                          if (cancelText != null)
                            Expanded(
                              child: CustomButton(
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                  onCancel?.call();
                                },
                                text: cancelText,
                                backgroundColor:
                                    cancelColor ??
                                    (isDarkMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200),
                                foregroundColor: isDarkMode
                                    ? Colors.white
                                    : Colors.grey.shade800,
                                borderColor: Colors.transparent,
                              ),
                            ),
                          if (cancelText != null && confirmText != null)
                            const SizedBox(width: Dimensions.paddingDefault),
                          if (confirmText != null)
                            Expanded(
                              child: CustomButton(
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                  onConfirm?.call();
                                },
                                text: confirmText,
                                backgroundColor:
                                    confirmColor ?? _getButtonColor(type),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          if (confirmText == null && cancelText == null)
                            Expanded(
                              child: CustomButton(
                                onPressed: () => Navigator.of(context).pop(),
                                text: 'OK',
                                backgroundColor: _getButtonColor(type),
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Color _getHeaderColor(DialogType type, bool isDarkMode) {
    switch (type) {
      case DialogType.success:
        return AppColors.successColor;
      case DialogType.error:
        return AppColors.errorColor;
      case DialogType.warning:
        return AppColors.warningColor;
      case DialogType.info:
        return AppColors.infoColor;
      case DialogType.confirmation:
        return AppColors.primaryColor;
      case DialogType.custom:
        return isDarkMode ? AppColors.darkPrimary : AppColors.primaryColor;
    }
  }

  static Color _getButtonColor(DialogType type) {
    switch (type) {
      case DialogType.success:
        return AppColors.successColor;
      case DialogType.error:
        return AppColors.errorColor;
      case DialogType.warning:
        return AppColors.warningColor;
      case DialogType.info:
        return AppColors.infoColor;
      case DialogType.confirmation:
        return AppColors.primaryColor;
      case DialogType.custom:
        return AppColors.primaryColor;
    }
  }

  static Color _getIconColor(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Colors.white;
      case DialogType.error:
        return Colors.white;
      case DialogType.warning:
        return Colors.white;
      case DialogType.info:
        return Colors.white;
      case DialogType.confirmation:
        return Colors.white;
      case DialogType.custom:
        return Colors.white;
    }
  }

  static IconData _getDialogIcon(DialogType type) {
    switch (type) {
      case DialogType.success:
        return Icons.check_circle;
      case DialogType.error:
        return Icons.error;
      case DialogType.warning:
        return Icons.warning;
      case DialogType.info:
        return Icons.info;
      case DialogType.confirmation:
        return Icons.help;
      case DialogType.custom:
        return Icons.info;
    }
  }

  // Success Dialog Shortcut
  static Future<void> showSuccess({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
  }) async {
    await show(
      context: context,
      type: DialogType.success,
      title: title,
      message: message,
      confirmText: buttonText ?? 'OK',
    );
  }

  // Error Dialog Shortcut
  static Future<void> showError({
    required BuildContext context,
    required String title,
    required String message,
    String? buttonText,
  }) async {
    await show(
      context: context,
      type: DialogType.error,
      title: title,
      message: message,
      confirmText: buttonText ?? 'OK',
    );
  }

  // Warning Dialog Shortcut
  static Future<void> showWarning({
    required BuildContext context,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
  }) async {
    await show(
      context: context,
      type: DialogType.warning,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
    );
  }

  // Confirmation Dialog Shortcut (with two buttons)
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) async {
    return await show(
      context: context,
      type: DialogType.confirmation,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: confirmColor,
    );
  }

  // Loading Dialog
  static Future<void> showLoading({
    required BuildContext context,
    String? message,
    bool dismissible = false,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: dismissible,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => dismissible,
          child: Dialog(
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingExtraLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryColor,
                      ),
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: Dimensions.paddingLarge),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Dismiss Loading Dialog
  static void dismissLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  // Custom Dialog with Image
  static Future<bool?> showImageDialog({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
  }) async {
    return await show(
      context: context,
      type: DialogType.custom,
      title: title,
      message: message,
      confirmText: confirmText,
      cancelText: cancelText,
      content: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
          const SizedBox(height: Dimensions.paddingLarge),
          Text(
            message,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
