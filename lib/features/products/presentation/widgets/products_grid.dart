import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/router/app_routes.dart';
import '../../data/models/product_model.dart';
import 'product_card.dart';

class ProductsGrid extends StatelessWidget {
  final List<ProductModel> products;

  final ValueChanged<ProductModel>? onProductTap;

  final Widget Function(ProductModel product)? actionBuilder;

  const ProductsGrid({
    super.key,
    required this.products,
    this.onProductTap,
    this.actionBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.spacing.md),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.responsive(
            mobile: 2,
            tablet: 4,
            desktop: 6,
          ),
          mainAxisSpacing: context.spacing.md,
          crossAxisSpacing: context.spacing.md,
          childAspectRatio: context.responsive(
            mobile: 0.62,
            tablet: 0.68,
            desktop: 0.72,
          ),
        ),
        delegate: SliverChildBuilderDelegate(
              (context, index) {
            final product = products[index];
            return ProductCard(
              product: product,
              action: actionBuilder?.call(product),
              onTap: () {
                final handler = onProductTap;
                if (handler != null) {
                  handler(product);
                } else {
                  context.push(AppRoutes.productPath(product.id));
                }
              },
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }
}
