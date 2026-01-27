import 'package:flutter/material.dart';

class ResponsiveLayout {
  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide >= 600;

  static double maxContentWidth(BuildContext context) =>
      isTablet(context) ? 720 : MediaQuery.of(context).size.width;

  static EdgeInsets screenPadding(BuildContext context) {
    final horizontal = isTablet(context) ? 32.0 : 16.0;
    final vertical = isTablet(context) ? 28.0 : 16.0;
    return EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  }

  static double sectionSpacing(BuildContext context) =>
      isTablet(context) ? 32.0 : 20.0;
}

