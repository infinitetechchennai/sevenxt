import 'package:flutter/material.dart';

/// Responsive breakpoints:
/// - Mobile: width < 600px
/// - Tablet: 600px - 900px
/// - Desktop: width > 900px
class Responsive extends StatelessWidget {
  const Responsive({super.key});

  /// Returns true if the screen width is less than 600px (mobile)
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  /// Returns true if the screen width is between 600px and 900px (tablet)
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 900;

  /// Returns true if the screen width is greater than 900px (desktop)
  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900;

  /// Returns the number of columns for a grid based on screen width
  /// - Mobile: 2 columns
  /// - Tablet: 3 columns
  /// - Desktop: 4 columns
  static int crossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 2;
    if (width < 900) return 3;
    return 4;
  }

  /// Returns the number of columns for category sections
  /// - Mobile: horizontal scroll (1)
  /// - Tablet: 2 columns
  /// - Desktop: 3-4 columns
  static int categoryCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 1; // horizontal scroll
    if (width < 900) return 2;
    if (width < 1200) return 3;
    return 4;
  }

  /// Returns appropriate padding based on screen size
  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 16.0;
    if (width < 900) return 24.0;
    return 32.0;
  }

  /// Returns appropriate banner height
  static double bannerHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 180.0;
    if (width < 900) return 220.0;
    return 280.0;
  }

  /// Returns appropriate product card aspect ratio
  static double productCardAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 0.65;
    if (width < 900) return 0.7;
    return 0.75;
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('Responsive is a utility class');
  }
}
