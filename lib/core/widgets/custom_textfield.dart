import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_styles.dart';
import '../constants/dimensions.dart';
import '../utils/responsive_layout.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final void Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final FocusNode? focusNode;
  final EdgeInsets? contentPadding;
  final Color? fillColor;
  final double? borderRadius;
  final bool showCounter;
  final String? errorText;
  final TextCapitalization textCapitalization;
  final String? helperText;
  final bool isRequired;
  final bool showLabel;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;
  final TextAlign textAlign;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.initialValue,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.autofocus = false,
    this.focusNode,
    this.contentPadding,
    this.fillColor,
    this.borderRadius,
    this.showCounter = false,
    this.errorText,
    this.textCapitalization = TextCapitalization.none,
    this.helperText,
    this.isRequired = false,
    this.showLabel = true,
    this.labelStyle,
    this.hintStyle,
    this.errorStyle,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveLayout.isWeb(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel && labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  labelText!,
                  style:
                      labelStyle ??
                      TextStyle(
                        fontSize: isWeb
                            ? Dimensions.fontSizeDefault
                            : Dimensions.fontSizeSmall,
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                      ),
                ),
                if (isRequired)
                  const Text(
                    ' *',
                    style: TextStyle(color: AppColors.errorColor, fontSize: 14),
                  ),
              ],
            ),
          ),
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          readOnly: readOnly,
          enabled: enabled,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          onTap: onTap,
          inputFormatters: inputFormatters,
          autofocus: autofocus,
          focusNode: focusNode,
          textCapitalization: textCapitalization,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: isWeb
                ? Dimensions.fontSizeDefault
                : Dimensions.fontSizeSmall,
            color: enabled ? AppColors.black : AppColors.grey,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle:
                hintStyle ??
                TextStyle(
                  color: AppColors.grey,
                  fontSize: isWeb
                      ? Dimensions.fontSizeDefault
                      : Dimensions.fontSizeSmall,
                ),
            prefixIcon: prefixIcon != null
                ? Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWeb
                          ? Dimensions.paddingDefault
                          : Dimensions.paddingSmall,
                    ),
                    child: prefixIcon,
                  )
                : null,
            suffixIcon: suffixIcon,
            contentPadding:
                contentPadding ??
                EdgeInsets.symmetric(
                  horizontal: isWeb
                      ? Dimensions.paddingDefault
                      : Dimensions.paddingSmall,
                  vertical: isWeb
                      ? Dimensions.paddingDefault
                      : Dimensions.paddingSmall,
                ),
            filled: true,
            fillColor: fillColor ?? Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? Dimensions.radiusDefault,
              ),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? Dimensions.radiusDefault,
              ),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? Dimensions.radiusDefault,
              ),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? Dimensions.radiusDefault,
              ),
              borderSide: const BorderSide(color: AppColors.errorColor),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? Dimensions.radiusDefault,
              ),
              borderSide: BorderSide(color: AppColors.errorColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? Dimensions.radiusDefault,
              ),
              borderSide: BorderSide(
                color: AppColors.lightGrey.withOpacity(0.5),
              ),
            ),
            errorText: errorText,
            errorStyle:
                errorStyle ??
                const TextStyle(color: AppColors.errorColor, fontSize: 12),
            helperText: helperText,
            counterText: showCounter ? null : '',
            counterStyle: const TextStyle(fontSize: 0),
          ),
        ),
      ],
    );
  }
}

// Search TextField
class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSearch;
  final ValueChanged<String>? onChanged;

  const SearchTextField({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onSearch,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search, color: AppColors.grey),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, color: AppColors.grey),
                onPressed: () {
                  controller.clear();
                  onChanged?.call('');
                },
              )
            : null,
        filled: true,
        fillColor: AppColors.lightGrey.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingDefault,
          vertical: Dimensions.paddingSmall,
        ),
      ),
    );
  }
}

// Dropdown Form Field
class CustomDropdownFormField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>>? items;
  final void Function(T?)? onChanged;
  final String? labelText;
  final String? hintText;
  final String? Function(T?)? validator;
  final bool isRequired;
  final bool enabled;

  const CustomDropdownFormField({
    super.key,
    this.value,
    this.items,
    this.onChanged,
    this.labelText,
    this.hintText,
    this.validator,
    this.isRequired = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Text(
                  labelText!,
                  style: const TextStyle(
                    fontSize: Dimensions.fontSizeSmall,
                    fontWeight: FontWeight.w500,
                    color: AppColors.darkGrey,
                  ),
                ),
                if (isRequired)
                  const Text(
                    ' *',
                    style: TextStyle(color: AppColors.errorColor, fontSize: 14),
                  ),
              ],
            ),
          ),
        DropdownButtonFormField<T>(
          value: value,
          items: items,
          onChanged: enabled ? onChanged : null,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: enabled
                ? Colors.white
                : AppColors.lightGrey.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              borderSide: const BorderSide(color: AppColors.lightGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
              borderSide: BorderSide(
                color: AppColors.lightGrey.withOpacity(0.5),
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingDefault,
              vertical: Dimensions.paddingSmall,
            ),
          ),
          validator: validator,
          style: TextStyle(
            fontSize: Dimensions.fontSizeSmall,
            color: enabled ? AppColors.black : AppColors.grey,
          ),
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: AppColors.grey),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
      ],
    );
  }
}
