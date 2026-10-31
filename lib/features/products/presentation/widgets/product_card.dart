import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;
  final Widget? action;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.thumbnail ??
        (product.images.isNotEmpty ? product.images.first : null);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(context.spacing.sm),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: AppRadius.card,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: AppRadius.card,
                child: AppNetworkImage(url: imageUrl),
              ),
            ),
            SizedBox(height: context.spacing.sm),
            Text(
              product.title,
              style: context.textStyles.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: context.spacing.xs),
            Row(
              children: [
                StarRating(rating: product.rating, size: 14),
                const Spacer(),
                if (!product.inStock)
                  Text(
                    'Out of stock',
                    style: context.textStyles.caption.copyWith(
                      color: AppColors.discount,
                    ),
                  ),
              ],
            ),
            SizedBox(height: context.spacing.xs),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '\$${product.discountedPrice.toStringAsFixed(2)}',
                        style: context.textStyles.price,
                      ),
                      SizedBox(height: context.spacing.xs),
                      if (product.hasDiscount)
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: context.textStyles.oldPrice,
                            ),
                            SizedBox(width: context.spacing.xs),
                            Flexible(
                              child: Text(
                                '${product.discountPercentage.toStringAsFixed(0)}% Off',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: context.textStyles.discount,
                              ),
                            ),
                          ],
                        )
                      else
                        Text(
                          product.brand ?? product.category,
                          style: context.textStyles.caption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
                if (action != null) action!,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
