import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/app_bottom_nav_bar.dart';

/// Bottom-navigation scaffold wrapped around the tab screens.
///
/// `navigationShell` is the current tab's screen (go_router keeps visited
/// tabs alive) and also the controller used to switch tabs. The branch order
/// in `app_router.dart` must match the order of the bottom bar items.
class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  static const int _homeTab = 0;

  @override
  Widget build(BuildContext context) {
    final currentIndex = navigationShell.currentIndex;

    return PopScope(
      // The system back button returns to Home before leaving the app.
      canPop: currentIndex == _homeTab,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) navigationShell.goBranch(_homeTab);
      },
      child: Scaffold(
        body: navigationShell,
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: currentIndex,
          // Tapping the active tab again returns to that tab's first screen.
          onTap: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == currentIndex,
          ),
          // TODO: feed the Cart badge from the cart state once the cart is
          // scoped to the signed-in user. Hidden while it is 0.
          cartCount: 0,
        ),
      ),
    );
  }
}
