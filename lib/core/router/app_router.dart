import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/views/login_view.dart';
import '../../features/cart/presentation/views/cart_view.dart';
import '../../features/category_feature/presentation/view/categort_view.dart';
import '../../features/home/presentation/views/main_shell.dart';
import '../../features/products/presentation/views/offer_view.dart';
import '../../features/products/presentation/views/product_detail_view.dart';
import '../../features/products/presentation/views/product_search_view.dart';
import '../../features/products/presentation/views/products_view.dart';
import '../../features/products/data/repositories/products_repository.dart';
import '../../features/ratings/data/repositories/ratings_repository.dart';
import '../../features/ratings/presentation/view_models/ratings_cubit.dart';
import '../../features/ratings/presentation/views/add_rating_view.dart';
import '../../features/ratings/presentation/views/rating_form_args.dart';
import '../../features/ratings/presentation/views/ratings_view.dart';
import '../services/service_locator.dart';
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
            MainShell(navigationShell: navigationShell),
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
              builder: (context, state) => const CategoryView(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartView(),
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
        path: AppRoutes.search,
        parentNavigatorKey: rootNavigatorKey,
        builder: (context, state) => const ProductSearchView(),
      ),
      GoRoute(
        path: AppRoutes.productDetails,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) => _invalidProductId(state),
        builder: (context, state) =>
            ProductDetailView(productId: _productId(state)),
      ),

      GoRoute(
        path: AppRoutes.ratings,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) => _invalidProductId(state),
        builder: (context, state) {
          final productId = _productId(state);
          return BlocProvider(
            create: (_) => RatingsCubit(
              repository: getIt<RatingsRepository>(),
              productsRepository: getIt<ProductsRepository>(),
              productId: productId,
            )..loadRatings(),
            child: RatingsView(productId: productId),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.addRating,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) => _ratingFormGuard(state),
        builder: (context, state) => _ratingForm(state, editing: false),
      ),
      GoRoute(
        path: AppRoutes.editRating,
        parentNavigatorKey: rootNavigatorKey,
        redirect: (context, state) => _ratingFormGuard(state),
        builder: (context, state) => _ratingForm(state, editing: true),
      ),
    ],
  );
}

int _productId(GoRouterState state) =>
    int.parse(state.pathParameters['id']!);

String? _invalidProductId(GoRouterState state) =>
    int.tryParse(state.pathParameters['id'] ?? '') == null
        ? AppRoutes.home
        : null;

String? _ratingFormGuard(GoRouterState state) {
  final invalid = _invalidProductId(state);
  if (invalid != null) return invalid;
  if (state.extra is RatingFormArgs) return null;
  return AppRoutes.ratingsPath(_productId(state));
}

Widget _ratingForm(GoRouterState state, {required bool editing}) {
  final args = state.extra! as RatingFormArgs;
  return BlocProvider.value(
    value: args.cubit,
    child: AddRatingView(
      productId: _productId(state),
      reviewerName: args.reviewerName,
      reviewerEmail: args.reviewerEmail,
      rating: editing ? args.rating : null,
    ),
  );
}
