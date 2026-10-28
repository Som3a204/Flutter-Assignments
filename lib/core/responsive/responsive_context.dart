import 'package:flutter/widgets.dart';
import 'breakpoints.dart';
import 'responsive_text_styles.dart';
import 'responsive_app_spacing.dart';

extension ResponsiveContext on BuildContext {
  T responsive<T>({required T mobile, T? tablet, T? desktop}) {
    if (Breakpoints.isDesktop(this)) return desktop ?? tablet ?? mobile;
    if (Breakpoints.isTablet(this)) return tablet ?? mobile;
    return mobile;
  }

  ResponsiveTextStyles get textStyles => ResponsiveTextStyles(this);
  ResponsiveAppSpacing get spacing => ResponsiveAppSpacing(this);
}
