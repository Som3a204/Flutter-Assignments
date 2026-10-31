import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../utils/product_variants.dart';

const double _kOptionSize = 48;

class ProductSizeSelector extends StatelessWidget {
  final List<String> sizes;
  final String? selectedSize;
  final ValueChanged<String> onSelected;

  const ProductSizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSize,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kOptionSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sizes.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: context.spacing.md),
        itemBuilder: (context, index) {
          final size = sizes[index];
          final isSelected = size == selectedSize;

          return GestureDetector(
            onTap: () => onSelected(size),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: _kOptionSize,
              height: _kOptionSize,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Text(
                size,
                style: context.textStyles.body.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProductColorSelector extends StatelessWidget {
  final List<ProductColorOption> colors;
  final ProductColorOption? selectedColor;
  final ValueChanged<ProductColorOption> onSelected;

  const ProductColorSelector({
    super.key,
    required this.colors,
    required this.selectedColor,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _kOptionSize,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: colors.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: context.spacing.md),
        itemBuilder: (context, index) {
          final option = colors[index];
          final isSelected = option.hex == selectedColor?.hex;

          return Tooltip(
            message: option.name,
            child: GestureDetector(
              onTap: () => onSelected(option),
              child: Container(
                width: _kOptionSize,
                height: _kOptionSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.color,
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }
}
