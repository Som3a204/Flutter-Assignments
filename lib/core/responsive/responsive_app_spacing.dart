import 'package:flutter/widgets.dart';

import 'responsive_context.dart';

class ResponsiveAppSpacing {
  final BuildContext context;
  
  final double? _xs;
  final double? _sm;
  final double? _md;
  final double? _lg;
  final double? _xl;
  final double? _xxl;

  ResponsiveAppSpacing(
    this.context, {
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  })  : _xs = xs,
        _sm = sm,
        _md = md,
        _lg = lg,
        _xl = xl,
        _xxl = xxl;

  double get xs => _xs ?? context.responsive(mobile: 4.0, tablet: 6.0, desktop: 8.0);
  double get sm => _sm ?? context.responsive(mobile: 8.0, tablet: 12.0, desktop: 16.0);
  double get md => _md ?? context.responsive(mobile: 16.0, tablet: 20.0, desktop: 24.0);
  double get lg => _lg ?? context.responsive(mobile: 24.0, tablet: 32.0, desktop: 40.0);
  double get xl => _xl ?? context.responsive(mobile: 32.0, tablet: 48.0, desktop: 64.0);
  double get xxl => _xxl ?? context.responsive(mobile: 48.0, tablet: 64.0, desktop: 80.0);

  ResponsiveAppSpacing copyWith({
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
  }) {
    return ResponsiveAppSpacing(
      context,
      xs: xs ?? _xs,
      sm: sm ?? _sm,
      md: md ?? _md,
      lg: lg ?? _lg,
      xl: xl ?? _xl,
      xxl: xxl ?? _xxl,
    );
  }
}

