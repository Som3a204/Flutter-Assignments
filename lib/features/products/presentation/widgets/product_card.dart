import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/responsive/responsive_context.dart';
import '../../data/models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    // Note: Assuming a simple calculation for discount percentage for display
    final double discountPercent = product.price > 0 
        ? ((product.price - product.discountPrice) / product.price * 100) 
        : 0;

    return Container(
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
              child: SizedBox(
                width: double.infinity,
                // In a real app we'd use Image.network, but using the placeholder logic from before
                child: Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(Icons.image, size: 50, color: AppColors.border),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            product.name,
            style: context.textStyles.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: context.spacing.xs),
          Row(
            children: [
              const Icon(Icons.star, color: AppColors.star, size: 12),
              const Icon(Icons.star, color: AppColors.star, size: 12),
              const Icon(Icons.star, color: AppColors.star, size: 12),
              const Icon(Icons.star, color: AppColors.star, size: 12),
              const Icon(Icons.star_border, color: AppColors.star, size: 12),
            ],
          ),
          SizedBox(height: context.spacing.xs),
          Text(
            '\$${product.discountPrice.toStringAsFixed(2)}',
            style: context.textStyles.price,
          ),
          SizedBox(height: context.spacing.xs),
          Row(
            children: [
              Text(
                '\$${product.price.toStringAsFixed(2)}',
                style: context.textStyles.oldPrice,
              ),
              SizedBox(width: context.spacing.xs),
              Flexible(
                child: Text(
                  '${discountPercent.toStringAsFixed(0)}% Off',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textStyles.discount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
