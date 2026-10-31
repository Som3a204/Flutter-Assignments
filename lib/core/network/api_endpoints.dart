class ApiEndpoints {
  ApiEndpoints._();

  // Base URL
  static const String baseUrl = 'https://dummyjson.com/';

  // Authentication Endpoints
  static const String login = 'auth/login';
  static const String refresh = 'auth/refresh';
  static const String me = 'auth/me';

  // Products Endpoints
  static const String products = 'products';
  static const String categories = 'products/categories';
  // Get product by ID
  static String productById(int id) => 'products/$id';
  // `GET products/category/{category}`
  static String productsByCategory(String category) =>
      'products/category/${Uri.encodeComponent(category)}';
  // Image generator: https://dummyjson.com/image/SIZE/BACKGROUND/COLOR
  static String generatedImage({
    required int width,
    required int height,
    required String backgroundHex,
    String? textHex,
  }) {
    final text = textHex ?? backgroundHex;
    return '${baseUrl}image/${width}x$height/$backgroundHex/$text';
  }

  // Users & Carts
  static const String users = 'users';
  static const String carts = 'carts';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);
}
