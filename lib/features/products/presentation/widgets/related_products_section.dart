import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../data/models/product_model.dart';
import 'product_card.dart';

class RelatedProductsSection extends StatelessWidget {
  final List<ProductModel> products;
  final ValueChanged<ProductModel> onProductTap;

  const RelatedProductsSection({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) return const SizedBox.shrink();

    final cardWidth =
        context.responsive(mobile: 160.0, tablet: 190.0, desktop: 210.0);
    final listHeight =
        context.responsive(mobile: 270.0, tablet: 310.0, desktop: 330.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
          child: Text('You Might Also Like', style: context.textStyles.heading4),
        ),
        SizedBox(height: context.spacing.md),
        SizedBox(
          height: listHeight,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
            itemCount: products.length,
            separatorBuilder: (context, index) =>
                SizedBox(width: context.spacing.md),
            itemBuilder: (context, index) {
              final product = products[index];
              return SizedBox(
                width: cardWidth,
                child: ProductCard(
                  product: product,
                  onTap: () => onProductTap(product),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
