import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Device type detection
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) {
      return DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  // Responsive values based on device type
  static T responsive<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  // Responsive padding
  static EdgeInsets responsivePadding(BuildContext context) {
    return responsive(
      context: context,
      mobile: const EdgeInsets.all(16),
      tablet: const EdgeInsets.all(24),
      desktop: const EdgeInsets.all(32),
    );
  }

  // Responsive text size
  static double responsiveTextSize({
    required BuildContext context,
    required double baseSize,
    double mobileScale = 1.0,
    double tabletScale = 1.1,
    double desktopScale = 1.2,
  }) {
    return responsive(
      context: context,
      mobile: baseSize * mobileScale,
      tablet: baseSize * tabletScale,
      desktop: baseSize * desktopScale,
    );
  }

  // Responsive grid columns
  static int responsiveColumns(BuildContext context) {
    return responsive(
      context: context,
      mobile: 1,
      tablet: 2,
      desktop: 3,
    );
  }

  // Responsive container width
  static double responsiveWidth({
    required BuildContext context,
    double mobilePercentage = 1.0,
    double tabletPercentage = 0.8,
    double desktopPercentage = 0.6,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final percentage = responsive(
      context: context,
      mobile: mobilePercentage,
      tablet: tabletPercentage,
      desktop: desktopPercentage,
    );
    return screenWidth * percentage;
  }

  // Responsive card elevation
  static double responsiveElevation(BuildContext context) {
    return responsive(
      context: context,
      mobile: 2.0,
      tablet: 4.0,
      desktop: 6.0,
    );
  }

  // Safe area wrapper
  static Widget safeAreaWrapper({
    required Widget child,
    bool top = true,
    bool bottom = true,
    bool left = true,
    bool right = true,
  }) {
    return SafeArea(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: child,
    );
  }

  // Responsive layout builder
  static Widget responsiveBuilder({
    required BuildContext context,
    required Widget Function(BuildContext, DeviceType) builder,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = getDeviceType(context);
        return builder(context, deviceType);
      },
    );
  }

  // Get screen size category
  static ScreenSize getScreenSize(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = (size.width * size.width + size.height * size.height) / 100;
    
    if (diagonal < 1154) {
      return ScreenSize.small;
    } else if (diagonal < 1425) {
      return ScreenSize.normal;
    } else if (diagonal < 1920) {
      return ScreenSize.large;
    } else {
      return ScreenSize.extraLarge;
    }
  }

  // Orientation specific values
  static T orientationValue<T>({
    required BuildContext context,
    required T portrait,
    required T landscape,
  }) {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.portrait ? portrait : landscape;
  }

  // Check if device is in landscape
  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  // Check if device is in portrait
  static bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // Get responsive icon size
  static double responsiveIconSize(BuildContext context) {
    return responsive(
      context: context,
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    );
  }

  // Get responsive button height
  static double responsiveButtonHeight(BuildContext context) {
    return responsive(
      context: context,
      mobile: 48.0,
      tablet: 52.0,
      desktop: 56.0,
    );
  }

  // Responsive margin
  static EdgeInsets responsiveMargin(BuildContext context) {
    return responsive(
      context: context,
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tablet: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      desktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    );
  }

  // Get app bar height based on device
  static double responsiveAppBarHeight(BuildContext context) {
    return responsive(
      context: context,
      mobile: kToolbarHeight,
      tablet: kToolbarHeight + 8,
      desktop: kToolbarHeight + 16,
    );
  }
}

// Device type enumeration
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

// Screen size enumeration
enum ScreenSize {
  small,
  normal,
  large,
  extraLarge,
}

// Responsive widget wrapper
class ResponsiveWidget extends StatelessWidget {
  final Widget Function(BuildContext, DeviceType) builder;
  
  const ResponsiveWidget({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveHelper.responsiveBuilder(
      context: context,
      builder: builder,
    );
  }
}

// Responsive container
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? color;
  final double? width;
  final double? height;
  
  const ResponsiveContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? ResponsiveHelper.responsiveWidth(context: context),
      height: height,
      padding: padding ?? ResponsiveHelper.responsivePadding(context),
      margin: margin ?? ResponsiveHelper.responsiveMargin(context),
      color: color,
      child: child,
    );
  }
}