import 'package:e_commerce/core/services/service_locator.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../models/product_model.dart';

class ProductsApiDatasource {
  DioClient get _dioClient => getIt<DioClient>();

  ProductsApiDatasource();

  /// Fetches a page of products from `GET /products`.
  Future<List<ProductModel>> fetchProducts({
    int limit = 20,
    int skip = 0,
  }) async {
    final response = await _dioClient.get(
      ApiEndpoints.products,
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return _parseProductList(response.data);
  }

  /// Fetches a single product from `GET /products/{id}`.
  Future<ProductModel> fetchProductById(int id) async {
    final response = await _dioClient.get(ApiEndpoints.productById(id));
    return ProductModel.fromJson(_asJsonMap(response.data));
  }

  /// Fetches products of one category from `GET /products/category/{category}`.
  Future<List<ProductModel>> fetchProductsByCategory(
      String category, {
        int limit = 10,
      }) async {
    final response = await _dioClient.get(
      ApiEndpoints.productsByCategory(category),
      queryParameters: {'limit': limit},
    );
    return _parseProductList(response.data);
  }

  List<ProductModel> _parseProductList(dynamic data) {
    final rawProducts = _asJsonMap(data)['products'];
    if (rawProducts is! List) {
      throw const ApiException(message: 'Unexpected response format.');
    }

    return rawProducts
        .whereType<Map>()
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Map<String, dynamic> _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    throw const ApiException(message: 'Unexpected response format.');
  }
}
