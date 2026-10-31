import 'package:flutter/material.dart';

import '../../../../core/widgets/placeholder_screen.dart';
import '../../../offers/presentation/views/offer_view.dart';
import '../../../products/presentation/views/products_view.dart';
import '../widgets/app_bottom_nav_bar.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const int _homeTab = 0;

  // TODO: replace with the real cart item count once the cart exists.
  static const int _cartCount = 2;

  int _currentIndex = _homeTab;

  void _selectTab(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // The system back button returns to Home before leaving the app.
      canPop: _currentIndex == _homeTab,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _selectTab(_homeTab);
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            const ProductsView(),
            const PlaceholderScreen(title: 'Explore', icon: Icons.search),
            const PlaceholderScreen(
              title: 'Cart',
              icon: Icons.shopping_cart_outlined,
            ),
            OfferView(onBack: () => _selectTab(_homeTab)),
            const PlaceholderScreen(
              title: 'Account',
              icon: Icons.person_outline,
            ),
          ],
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _selectTab,
          cartCount: _cartCount,
        ),
      ),
    );
  }
}
