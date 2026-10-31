import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_screen_bar.dart';
import '../../../products/presentation/utils/sample_products.dart';
import '../../../products/presentation/widgets/products_grid.dart';
import '../widgets/flash_sale_banner.dart';

class OfferView extends StatelessWidget {

  final VoidCallback? onBack;

  const OfferView({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppScreenBar(
        title: 'Super Flash Sale',
        onBack: onBack,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(spacing.md),
            sliver: const SliverToBoxAdapter(
              child: FlashSaleBanner(
                title: 'Super Flash Sale',
                subtitle: '50% Off',
                remaining: Duration(hours: 8, minutes: 34, seconds: 52),
              ),
            ),
          ),
          ProductsGrid(
            products: sampleProducts,
          ),
          SliverToBoxAdapter(child: SizedBox(height: spacing.lg)),
        ],
      ),
    );
  }
}
