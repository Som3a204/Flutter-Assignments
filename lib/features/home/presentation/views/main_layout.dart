import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  static const int _homeTab = 0;

  // TODO: replace with the real cart item count once the cart exists.
  static const int _cartCount = 2;

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return PopScope(
      canPop: currentIndex == _homeTab,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) navigationShell.goBranch(_homeTab);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          ),
          cartCount: _cartCount,
        ),
      ),
    );
  }
}
