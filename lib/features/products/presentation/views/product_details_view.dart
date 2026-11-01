import 'package:e_commerce/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/router/navigation_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository.dart';
import '../utils/product_variants.dart';
import '../view_models/product_details_cubit.dart';
import '../view_models/product_details_state.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_reviews_section.dart';
import '../widgets/product_specification.dart';
import '../widgets/related_products_section.dart';
import '../widgets/variant_selectors.dart';

class ProductDetailsView extends StatelessWidget {
  final int productId;

  const ProductDetailsView({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailsCubit(
        getIt<ProductsRepository>(),
        productId: productId,
      )..load(),
      child: const _ProductDetailsScreen(),
    );
  }
}

class _ProductDetailsScreen extends StatelessWidget {
  const _ProductDetailsScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
      builder: (context, state) {
        final loaded = state is ProductDetailsLoaded ? state : null;

        return Scaffold(
          appBar: _buildAppBar(context, loaded?.product.title ?? ''),
          body: switch (state) {
            ProductDetailsLoaded loadedState =>
                _ProductDetailsContent(state: loadedState),
            ProductDetailsError(:final message) => _ErrorBody(
              message: message,
              onRetry: () => context.read<ProductDetailsCubit>().load(),
            ),
            ProductDetailsLoading() || ProductDetailsInitial() => const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          },
          bottomNavigationBar: loaded == null
              ? null
              : _AddToCartBar(
            onPressed: () {
              // TODO: hook up once the cart feature exists.
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart is coming soon.')),
              );
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
    return AppBar(
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new,
            size: 20, color: AppColors.textSecondary),
        onPressed: context.popOrGoHome,
      ),
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textStyles.heading4,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1),
      ),
    );
  }
}

class _ProductDetailsContent extends StatelessWidget {
  final ProductDetailsLoaded state;

  const _ProductDetailsContent({required this.state});

  @override
  Widget build(BuildContext context) {
    final product = state.product;
    final cubit = context.read<ProductDetailsCubit>();
    final spacing = context.spacing;
    final images = product.images.isNotEmpty
        ? product.images
        : [if (product.thumbnail != null) product.thumbnail!];

    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProductImageGallery(
                images: images,
                variantImageUrl: state.variantImageUrl,
                scale: state.imageScale,
              ),
              Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TitleRow(product: product),
                    SizedBox(height: spacing.xs),
                    StarRating(rating: product.rating),
                    SizedBox(height: spacing.sm),
                    _PriceRow(product: product),
                    if (state.isWearable) ...[
                      SizedBox(height: spacing.lg),
                      Text('Select Size', style: context.textStyles.heading4),
                      SizedBox(height: spacing.md),
                      ProductSizeSelector(
                        sizes: productSizes,
                        selectedSize: state.selectedSize,
                        onSelected: cubit.selectSize,
                      ),
                      SizedBox(height: spacing.lg),
                      Text('Select Color', style: context.textStyles.heading4),
                      SizedBox(height: spacing.md),
                      ProductColorSelector(
                        colors: kProductColors,
                        selectedColor: state.selectedColor,
                        onSelected: cubit.selectColor,
                      ),
                    ],
                    SizedBox(height: spacing.lg),
                    Text('Specification', style: context.textStyles.heading4),
                    SizedBox(height: spacing.sm),
                    ProductSpecification(product: product),
                    SizedBox(height: spacing.lg),
                    ProductReviewsSection(
                      rating: product.rating,
                      reviews: product.reviews,
                    ),
                  ],
                ),
              ),
              RelatedProductsSection(
                products: state.relatedProducts,
                onProductTap: (related) =>
                    context.push(AppRoutes.productPath(related.id)),
              ),
              SizedBox(height: spacing.lg),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final ProductModel product;

  const _TitleRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(product.title, style: context.textStyles.heading3),
        ),
        IconButton(
          // TODO: wire to favourites once that feature exists.
          icon: const Icon(Icons.favorite_border,
              color: AppColors.textSecondary),
          onPressed: () {},
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final ProductModel product;

  const _PriceRow({required this.product});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: context.spacing.sm,
      children: [
        Text(
          '\$${product.discountedPrice.toStringAsFixed(2)}',
          style: context.textStyles.heading3
              .copyWith(color: AppColors.primary),
        ),
        if (product.hasDiscount) ...[
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: context.textStyles.oldPrice,
          ),
          Text(
            '${product.discountPercentage.toStringAsFixed(0)}% Off',
            style: context.textStyles.discount,
          ),
        ],
      ],
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddToCartBar({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Container(
      padding: EdgeInsets.fromLTRB(spacing.md, spacing.sm, spacing.md, spacing.md),
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: AppButton(text: 'Add To Cart', onPressed: onPressed),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBody({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded,
                size: 40, color: AppColors.textSecondary),
            SizedBox(height: context.spacing.md),
            Text('Something went wrong', style: context.textStyles.heading4),
            SizedBox(height: context.spacing.xs),
            Text(
              message,
              style: context.textStyles.body,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.spacing.lg),
            SizedBox(
              width: 180,
              child: AppButton(text: 'Retry', onPressed: onRetry),
            ),
          ],
        ),
      ),
    );
  }
}
