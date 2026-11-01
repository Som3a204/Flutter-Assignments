import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_screen_bar.dart';
import '../../../products/data/models/product_model.dart';
import '../../../products/presentation/utils/sample_products.dart';
import '../../../products/presentation/widgets/products_grid.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  late final List<ProductModel> _favorites = List.of(sampleProducts);

  void _remove(ProductModel product) {
    setState(() => _favorites.remove(product));
  }

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Scaffold(
      appBar: const AppScreenBar(title: 'Favorite Product'),
      body: _favorites.isEmpty
          ? const _EmptyFavorites()
          : CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: spacing.md)),
          ProductsGrid(
            products: _favorites,
            // Sample Data
            onProductTap: (_) {},
            actionBuilder: (product) =>
                _RemoveButton(onPressed: () => _remove(product)),
          ),
          SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),
        ],
      ),
    );
  }
}

class _RemoveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _RemoveButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Remove',
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      visualDensity: VisualDensity.compact,
      icon: const Icon(Icons.delete_outline, color: AppColors.textSecondary),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border,
              size: 56, color: AppColors.textSecondary),
          SizedBox(height: context.spacing.md),
          Text('No favorite products yet',
              style: context.textStyles.heading4),
        ],
      ),
    );
  }
}
