import 'package:flutter/widgets.dart';
import '../theme/app_colors.dart';
import 'responsive_context.dart';

class ResponsiveTextStyles {
  final BuildContext context;
  
  final TextStyle? _heading1;
  final TextStyle? _heading2;
  final TextStyle? _heading3;
  final TextStyle? _heading4;
  final TextStyle? _title;
  final TextStyle? _body;
  final TextStyle? _caption;
  final TextStyle? _price;
  final TextStyle? _oldPrice;
  final TextStyle? _discount;

  ResponsiveTextStyles(
    this.context, {
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? heading3,
    TextStyle? heading4,
    TextStyle? title,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? price,
    TextStyle? oldPrice,
    TextStyle? discount,
  })  : _heading1 = heading1,
        _heading2 = heading2,
        _heading3 = heading3,
        _heading4 = heading4,
        _title = title,
        _body = body,
        _caption = caption,
        _price = price,
        _oldPrice = oldPrice,
        _discount = discount;

  TextStyle _style(double mobile, double tablet, double desktop,
      {FontWeight weight = FontWeight.w400, Color color = AppColors.textPrimary}) {
    return TextStyle(
      fontSize: context.responsive(mobile: mobile, tablet: tablet, desktop: desktop),
      fontWeight: weight,
      color: color,
    );
  }

  TextStyle get heading1 => _heading1 ?? _style(32, 36, 40, weight: FontWeight.w700);
  TextStyle get heading2 => _heading2 ?? _style(24, 28, 32, weight: FontWeight.w700);
  TextStyle get heading3 => _heading3 ?? _style(20, 24, 28, weight: FontWeight.w700);
  TextStyle get heading4 => _heading4 ?? _style(16, 18, 20, weight: FontWeight.w700);
  TextStyle get title => _title ?? _style(14, 16, 18, weight: FontWeight.w700);
  TextStyle get body => _body ?? _style(12, 14, 15, color: AppColors.textSecondary);
  TextStyle get caption => _caption ?? _style(10, 12, 13, color: AppColors.textSecondary);
  
  TextStyle get price => _price ?? _style(14, 16, 18, weight: FontWeight.w700, color: AppColors.primary);
  TextStyle get oldPrice => _oldPrice ?? _style(10, 12, 13, color: AppColors.textSecondary).copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get discount => _discount ?? _style(10, 12, 13, color: AppColors.discount);

  ResponsiveTextStyles copyWith({
    TextStyle? heading1,
    TextStyle? heading2,
    TextStyle? heading3,
    TextStyle? heading4,
    TextStyle? title,
    TextStyle? body,
    TextStyle? caption,
    TextStyle? price,
    TextStyle? oldPrice,
    TextStyle? discount,
  }) {
    return ResponsiveTextStyles(
      context,
      heading1: heading1 ?? _heading1,
      heading2: heading2 ?? _heading2,
      heading3: heading3 ?? _heading3,
      heading4: heading4 ?? _heading4,
      title: title ?? _title,
      body: body ?? _body,
      caption: caption ?? _caption,
      price: price ?? _price,
      oldPrice: oldPrice ?? _oldPrice,
      discount: discount ?? _discount,
    );
  }
}
