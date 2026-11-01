/// Every route path and name in one place, so no screen hard-codes strings.
abstract final class AppRoutes {
  // Auth
  static const String login = '/login';

  // Bottom-navigation tabs
  static const String home = '/home';
  static const String explore = '/explore';
  static const String cart = '/cart';
  static const String offer = '/offer';
  static const String account = '/account';

  // Screens opened above the tabs
  static const String favorites = '/favorites';

  static const String productDetails = '/product/:id';
  static const String productDetailsName = 'product-details';

  static String productPath(int id) => '/product/$id';
}
