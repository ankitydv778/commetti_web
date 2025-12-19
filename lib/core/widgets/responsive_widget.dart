import 'package:flutter/material.dart';
import '../constants/dimensions.dart';
import '../utils/responsive_layout.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? web;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.web,
  });

  @override
  Widget build(BuildContext context) {
    // Use the layout detection methods instead of direct size checks
    if (ResponsiveLayout.isWeb(context) && web != null) {
      return web!;
    }

    if (ResponsiveLayout.isDesktop(context) && desktop != null) {
      return desktop!;
    }

    if (ResponsiveLayout.isTablet(context) && tablet != null) {
      return tablet!;
    }

    return mobile;
  }
}

// Responsive Builder with web support
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    bool isMobile,
    bool isTablet,
    bool isDesktop,
    bool isWeb,
  )
  builder;

  const ResponsiveBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = ResponsiveLayout.isMobile(context);
    final bool isTablet = ResponsiveLayout.isTablet(context);
    final bool isDesktop = ResponsiveLayout.isDesktop(context);
    final bool isWeb = ResponsiveLayout.isWeb(context);

    return builder(context, isMobile, isTablet, isDesktop, isWeb);
  }
}

// Responsive Grid with web support
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final int? webColumns;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 16,
    this.mainAxisSpacing = 16,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.webColumns,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = ResponsiveLayout.responsiveValueWithWeb(
          context,
          mobile: mobileColumns ?? 1,
          tablet: tabletColumns ?? 2,
          desktop: desktopColumns ?? 3,
          web: webColumns ?? 4,
        );

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        );
      },
    );
  }
}

// Responsive Padding with web support
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsets? mobilePadding;
  final EdgeInsets? tabletPadding;
  final EdgeInsets? desktopPadding;
  final EdgeInsets? webPadding;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.mobilePadding,
    this.tabletPadding,
    this.desktopPadding,
    this.webPadding,
  });

  @override
  Widget build(BuildContext context) {
    final padding = _getResponsivePadding(context);

    return Padding(padding: padding, child: child);
  }

  EdgeInsets _getResponsivePadding(BuildContext context) {
    // Use the new method with web support
    return EdgeInsets.all(
      ResponsiveLayout.responsiveValueWithWeb(
        context,
        mobile: _getPaddingValue(mobilePadding),
        tablet: _getPaddingValue(tabletPadding),
        desktop: _getPaddingValue(desktopPadding),
        web: _getPaddingValue(webPadding),
      ),
    );
  }

  double _getPaddingValue(EdgeInsets? padding) {
    if (padding != null) {
      return padding.top; // Assuming symmetric padding
    }
    return Dimensions.paddingDefault;
  }
}

// Responsive Padding with more control
class AdaptivePadding extends StatelessWidget {
  final Widget child;
  final double mobile;
  final double tablet;
  final double desktop;
  final double web;

  const AdaptivePadding({
    super.key,
    required this.child,
    this.mobile = Dimensions.paddingDefault,
    this.tablet = Dimensions.paddingLarge,
    this.desktop = Dimensions.paddingExtraLarge,
    this.web = Dimensions.paddingExtraLarge,
  });

  @override
  Widget build(BuildContext context) {
    final paddingValue = ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      web: web,
    );

    return Padding(padding: EdgeInsets.all(paddingValue), child: child);
  }
}

// Responsive Text with web support
class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;
  final double? webFontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool softWrap;

  const ResponsiveText({
    super.key,
    required this.text,
    this.style,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
    this.webFontSize,
    this.color,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize = _getResponsiveFontSize(context);

    return Text(
      text,
      style:
          style?.copyWith(
            fontSize: fontSize,
            color: color,
            fontWeight: fontWeight,
          ) ??
          TextStyle(fontSize: fontSize, color: color, fontWeight: fontWeight),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }

  double _getResponsiveFontSize(BuildContext context) {
    return ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobileFontSize ?? Dimensions.fontSizeDefault,
      tablet: tabletFontSize ?? Dimensions.fontSizeMedium,
      desktop: desktopFontSize ?? Dimensions.fontSizeLarge,
      web: webFontSize ?? Dimensions.fontSizeExtraLarge,
    );
  }
}

// Responsive Container with web support
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double? mobileWidth;
  final double? tabletWidth;
  final double? desktopWidth;
  final double? webWidth;
  final EdgeInsets? padding;
  final Alignment? alignment;
  final BoxConstraints? constraints;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.mobileWidth,
    this.tabletWidth,
    this.desktopWidth,
    this.webWidth,
    this.padding,
    this.alignment,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    final width = _getResponsiveWidth(context);

    return Container(
      width: width,
      padding: padding,
      alignment: alignment,
      constraints: constraints,
      child: child,
    );
  }

  double? _getResponsiveWidth(BuildContext context) {
    return ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobileWidth,
      tablet: tabletWidth,
      desktop: desktopWidth,
      web: webWidth,
    );
  }
}

// Responsive SizedBox
class ResponsiveSizedBox extends StatelessWidget {
  final double? mobileHeight;
  final double? tabletHeight;
  final double? desktopHeight;
  final double? webHeight;
  final double? mobileWidth;
  final double? tabletWidth;
  final double? desktopWidth;
  final double? webWidth;
  final Widget? child;

  const ResponsiveSizedBox({
    super.key,
    this.mobileHeight,
    this.tabletHeight,
    this.desktopHeight,
    this.webHeight,
    this.mobileWidth,
    this.tabletWidth,
    this.desktopWidth,
    this.webWidth,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final height = _getResponsiveHeight(context);
    final width = _getResponsiveWidth(context);

    return SizedBox(height: height, width: width, child: child);
  }

  double? _getResponsiveHeight(BuildContext context) {
    return ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobileHeight,
      tablet: tabletHeight,
      desktop: desktopHeight,
      web: webHeight,
    );
  }

  double? _getResponsiveWidth(BuildContext context) {
    return ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobileWidth,
      tablet: tabletWidth,
      desktop: desktopWidth,
      web: webWidth,
    );
  }
}

// Responsive Aspect Ratio
class ResponsiveAspectRatio extends StatelessWidget {
  final Widget child;
  final double mobileRatio;
  final double tabletRatio;
  final double desktopRatio;
  final double webRatio;

  const ResponsiveAspectRatio({
    super.key,
    required this.child,
    this.mobileRatio = 16 / 9,
    this.tabletRatio = 3 / 2,
    this.desktopRatio = 4 / 3,
    this.webRatio = 16 / 9,
  });

  @override
  Widget build(BuildContext context) {
    final aspectRatio = ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobileRatio,
      tablet: tabletRatio,
      desktop: desktopRatio,
      web: webRatio,
    );

    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }
}

// Responsive Spacer
class ResponsiveSpacer extends StatelessWidget {
  final double mobile;
  final double tablet;
  final double desktop;
  final double web;

  const ResponsiveSpacer({
    super.key,
    this.mobile = 8.0,
    this.tablet = 16.0,
    this.desktop = 24.0,
    this.web = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      web: web,
    );

    return SizedBox(height: spacing);
  }
}

// Responsive Expanded
class ResponsiveExpanded extends StatelessWidget {
  final Widget child;
  final int? mobileFlex;
  final int? tabletFlex;
  final int? desktopFlex;
  final int? webFlex;

  const ResponsiveExpanded({
    super.key,
    required this.child,
    this.mobileFlex,
    this.tabletFlex,
    this.desktopFlex,
    this.webFlex,
  });

  @override
  Widget build(BuildContext context) {
    final flex = ResponsiveLayout.responsiveValueWithWeb(
      context,
      mobile: mobileFlex ?? 1,
      tablet: tabletFlex ?? 1,
      desktop: desktopFlex ?? 1,
      web: webFlex ?? 1,
    );

    return Expanded(flex: flex, child: child);
  }
}

// Responsive Layout Builder
class ResponsiveLayoutBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, Size size, String screenType)
  builder;

  const ResponsiveLayoutBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        final screenType = ResponsiveLayout.screenType(context);

        return builder(context, size, screenType);
      },
    );
  }
}

// import 'package:committee/core/utils/responsive_layout.dart';
// import 'package:flutter/material.dart';
// import '../constants/dimensions.dart'; 

// class ResponsiveWidget extends StatelessWidget {
//   final Widget mobile;
//   final Widget? tablet;
//   final Widget? desktop;
//   final Widget? web;

//   const ResponsiveWidget({
//     super.key,
//     required this.mobile,
//     this.tablet,
//     this.desktop,
//     this.web,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
    
//     if (web != null && size.width >= Dimensions.desktopWidth) {
//       return web!;
//     }
    
//     if (desktop != null && size.width >= Dimensions.tabletWidth) {
//       return desktop!;
//     }
    
//     if (tablet != null && size.width >= Dimensions.mobileWidth) {
//       return tablet!;
//     }
    
//     return mobile;
//   }
// }

// // Responsive Builder
// class ResponsiveBuilder extends StatelessWidget {
//   final Widget Function(BuildContext context, bool isMobile, bool isTablet, bool isDesktop, bool isWeb) builder;

//   const ResponsiveBuilder({
//     super.key,
//     required this.builder,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final bool isMobile = ResponsiveLayout.isMobile(context);
//     final bool isTablet = ResponsiveLayout.isTablet(context);
//     final bool isDesktop = ResponsiveLayout.isDesktop(context);
//     final bool isWeb = ResponsiveLayout.isWeb(context);
    
//     return builder(context, isMobile, isTablet, isDesktop, isWeb);
//   }
// }

// // Responsive Grid
// class ResponsiveGrid extends StatelessWidget {
//   final List<Widget> children;
//   final double childAspectRatio;
//   final double crossAxisSpacing;
//   final double mainAxisSpacing;

//   const ResponsiveGrid({
//     super.key,
//     required this.children,
//     this.childAspectRatio = 1.0,
//     this.crossAxisSpacing = 16,
//     this.mainAxisSpacing = 16,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         int crossAxisCount = ResponsiveLayout.gridColumns(context);
        
//         return GridView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: crossAxisCount,
//             childAspectRatio: childAspectRatio,
//             crossAxisSpacing: crossAxisSpacing,
//             mainAxisSpacing: mainAxisSpacing,
//           ),
//           itemCount: children.length,
//           itemBuilder: (context, index) => children[index],
//         );
//       },
//     );
//   }
// }

// // Responsive Padding
// class ResponsivePadding extends StatelessWidget {
//   final Widget child;
//   final EdgeInsets? mobilePadding;
//   final EdgeInsets? tabletPadding;
//   final EdgeInsets? desktopPadding;
//   final EdgeInsets? webPadding;

//   const ResponsivePadding({
//     super.key,
//     required this.child,
//     this.mobilePadding,
//     this.tabletPadding,
//     this.desktopPadding,
//     this.webPadding,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final padding = ResponsiveLayout.responsiveValue(
//       context,
//       mobile: mobilePadding ?? const EdgeInsets.all(Dimensions.paddingDefault),
//       tablet: tabletPadding ?? const EdgeInsets.all(Dimensions.paddingLarge),
//       desktop: desktopPadding ?? const EdgeInsets.all(Dimensions.paddingExtraLarge),
//       web: webPadding ?? const EdgeInsets.all(Dimensions.paddingExtraLarge),
//     );
    
//     return Padding(
//       padding: padding,
//       child: child,
//     );
//   }
// }

// // Responsive Text
// class ResponsiveText extends StatelessWidget {
//   final String text;
//   final TextStyle? style;
//   final double? fontSize;
//   final Color? color;
//   final FontWeight? fontWeight;
//   final TextAlign? textAlign;
//   final int? maxLines;
//   final TextOverflow? overflow;
//   final bool softWrap;

//   const ResponsiveText({
//     super.key,
//     required this.text,
//     this.style,
//     this.fontSize,
//     this.color,
//     this.fontWeight,
//     this.textAlign,
//     this.maxLines,
//     this.overflow,
//     this.softWrap = true,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final double responsiveFontSize = ResponsiveLayout.responsiveFontSize(
//       context,
//       fontSize ?? Dimensions.fontSizeDefault,
//     );
    
//     return Text(
//       text,
//       style: style?.copyWith(
//             fontSize: responsiveFontSize,
//             color: color,
//             fontWeight: fontWeight,
//           ) ??
//           TextStyle(
//             fontSize: responsiveFontSize,
//             color: color,
//             fontWeight: fontWeight,
//           ),
//       textAlign: textAlign,
//       maxLines: maxLines,
//       overflow: overflow,
//       softWrap: softWrap,
//     );
//   }
// }

// // Responsive Container
// class ResponsiveContainer extends StatelessWidget {
//   final Widget child;
//   final double? mobileWidth;
//   final double? tabletWidth;
//   final double? desktopWidth;
//   final double? webWidth;
//   final EdgeInsets? padding;
//   final Alignment? alignment;

//   const ResponsiveContainer({
//     super.key,
//     required this.child,
//     this.mobileWidth,
//     this.tabletWidth,
//     this.desktopWidth,
//     this.webWidth,
//     this.padding,
//     this.alignment,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final width = ResponsiveLayout.responsiveValue(
//       context,
//       mobile: mobileWidth,
//       tablet: tabletWidth,
//       desktop: desktopWidth,
//       web: webWidth,
//     );
    
//     return Container(
//       width: width,
//       padding: padding,
//       alignment: alignment,
//       child: child,
//     );
//   }
// }