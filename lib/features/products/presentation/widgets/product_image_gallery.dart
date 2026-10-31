import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_network_image.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final String? variantImageUrl;
  final double scale;

  const ProductImageGallery({
    super.key,
    required this.images,
    this.variantImageUrl,
    this.scale = 1,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height =
        context.responsive(mobile: 260.0, tablet: 340.0, desktop: 400.0);
    final hasVariantTile = widget.variantImageUrl != null;
    final side = height * widget.scale;

    final pages = PageView.builder(
      controller: _pageController,
      itemCount: widget.images.isEmpty ? 1 : widget.images.length,
      onPageChanged: (index) => setState(() => _currentPage = index),
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: AppNetworkImage(
          url: widget.images.isEmpty ? null : widget.images[index],
          fit: BoxFit.contain,
        ),
      ),
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: height,
          color: AppColors.surface,
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            width: hasVariantTile ? side : double.infinity,
            height: hasVariantTile ? side : height,
            child: hasVariantTile
                ? ClipRRect(
                    borderRadius: AppRadius.lg,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AppNetworkImage(
                          url: widget.variantImageUrl,
                          showLoader: false,
                          gaplessPlayback: true,
                        ),
                        pages,
                      ],
                    ),
                  )
                : pages,
          ),
        ),
        if (widget.images.length > 1)
          Padding(
            padding: EdgeInsets.symmetric(vertical: context.spacing.sm),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentPage
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
