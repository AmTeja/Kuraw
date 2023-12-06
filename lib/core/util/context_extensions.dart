import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

extension ContextExt on BuildContext {
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;
  double get rWidth =>
      ResponsiveBreakpoints.of(this).isMobile ? width * 0.95 : width * 0.6;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  Future<T?> push<T extends Object?>(Route<T> r) {
    return Navigator.of(this).push<T>(r);
  }
}
