import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/product_model.dart';

class ProductSpecification extends StatelessWidget {
  final ProductModel product;

  const ProductSpecification({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      if (_has(product.brand)) ('Brand', product.brand!),
      if (_has(product.category)) ('Category', _prettify(product.category)),
      if (_has(product.sku)) ('SKU', product.sku),
      if (_has(product.availabilityStatus))
        ('Availability', '${product.availabilityStatus} (${product.stock} left)'),
      if (_has(product.warrantyInformation))
        ('Warranty', product.warrantyInformation!),
      if (_has(product.shippingInformation))
        ('Shipping', product.shippingInformation!),
      if (_has(product.returnPolicy)) ('Returns', product.returnPolicy!),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (label, value) in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$label:',
                  style: context.textStyles.body
                      .copyWith(color: AppColors.textPrimary),
                ),
                SizedBox(width: context.spacing.md),
                Expanded(
                  child: Text(
                    value,
                    textAlign: TextAlign.right,
                    style: context.textStyles.body,
                  ),
                ),
              ],
            ),
          ),
        if (product.description.isNotEmpty) ...[
          SizedBox(height: context.spacing.sm),
          Text(
            product.description,
            style: context.textStyles.body.copyWith(height: 1.7),
          ),
        ],
      ],
    );
  }

  static bool _has(String? value) => value != null && value.isNotEmpty;

  static String _prettify(String slug) {
    final text = slug.replaceAll('-', ' ');
    return text[0].toUpperCase() + text.substring(1);
  }
}
