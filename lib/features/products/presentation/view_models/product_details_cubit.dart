import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/api_exceptions.dart';
import '../../data/models/product_model.dart';
import '../../data/repositories/products_repository.dart';
import '../utils/product_variants.dart';
import 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final ProductsRepository _repository;
  final int productId;

  ProductDetailsCubit(this._repository, {required this.productId})
      : super(const ProductDetailsInitial());

  Future<void> load() async {
    emit(const ProductDetailsLoading());

    try {
      final product = await _repository.getProductById(productId);
      if (isClosed) return;

      emit(
        ProductDetailsLoaded(
          product: product,
          selectedSize: product.isWearable ? kDefaultSize : null,
          selectedColor: product.isWearable ? kProductColors.first : null,
        ),
      );

      await _loadRelated(product);
    } on ApiException catch (error) {
      if (isClosed) return;
      emit(ProductDetailsError(error.message));
    } catch (_) {
      if (isClosed) return;
      emit(const ProductDetailsError('Something went wrong. Please try again.'));
    }
  }

  void selectSize(String size) {
    final current = state;
    if (current is! ProductDetailsLoaded || !current.isWearable) return;
    emit(current.copyWith(selectedSize: size));
  }

  void selectColor(ProductColorOption color) {
    final current = state;
    if (current is! ProductDetailsLoaded || !current.isWearable) return;
    emit(current.copyWith(selectedColor: color));
  }

  Future<void> _loadRelated(ProductModel product) async {
    try {
      final items = await _repository.getProductsByCategory(
        product.category,
        limit: 11,
      );

      final current = state;
      if (isClosed ||
          current is! ProductDetailsLoaded ||
          current.product.id != product.id) {
        return;
      }

      final related =
          items.where((p) => p.id != product.id).take(10).toList();
      emit(current.copyWith(relatedProducts: related));
    } catch (_) {
    }
  }
}
