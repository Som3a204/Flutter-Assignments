abstract final class AppRoutes {
  // Auth
  static const String login = '/login';

  // Bottom-navigation tabs
  static const String home = '/home';
  static const String explore = '/explore';
  static const String cart = '/cart';
  static const String offer = '/offer';
  static const String account = '/account';

  static const String search = '/search';

  static const String productDetails = '/product/:id';
  static const String ratings = '/product/:id/ratings';
  static const String addRating = '/product/:id/ratings/add';
  static const String editRating = '/product/:id/ratings/edit';

  static String productPath(int id) => '/product/$id';
  static String ratingsPath(int id) => '/product/$id/ratings';
  static String addRatingPath(int id) => '/product/$id/ratings/add';
  static String editRatingPath(int id) => '/product/$id/ratings/edit';
}
