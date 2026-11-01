import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/views/login.dart';
import '../../features/favorites/presentation/views/favorite_view.dart';
import '../../features/home/presentation/views/main_layout.dart';
import '../../features/offers/presentation/views/offer_view.dart';
import '../../features/products/presentation/views/product_details_view.dart';
import '../../features/products/presentation/views/products_view.dart';
import '../widgets/placeholder_screen.dart';
import 'app_routes.dart';
import 'auth_notifier.dart';

GoRouter createRouter(AuthNotifier authNotifier) {

  final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.home,

    refreshListenable: authNotifier,

    redirect: (context, state) {
      final isLoggedIn = authNotifier.isLoggedIn;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn) return isOnLogin ? null : AppRoutes.login;
      if (isOnLogin) return AppRoutes.home;
      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginView(),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainLayout(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const ProductsView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.explore,
              builder: (context, state) => const PlaceholderScreen(
                title: 'Explore',
                icon: Icons.search,
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const PlaceholderScreen(
                title: 'Cart',
                icon: Icons.shopping_cart_outlined,
              ),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.offer,
              builder: (context, state) => const OfferView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.account,
              builder: (context, state) => const PlaceholderScreen(
                title: 'Account',
                icon: Icons.person_outline,
              ),
            ),
          ]),
        ],
      ),

      GoRoute(
        path: AppRoutes.favorites,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const FavoriteView(),
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        name: AppRoutes.productDetailsName,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) =>
            int.tryParse(state.pathParameters['id'] ?? '') == null
                ? AppRoutes.home
                : null,
        builder: (context, state) => ProductDetailsView(
          productId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );
}
