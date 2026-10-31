import '../../../../core/network/api_endpoints.dart';
import '../../data/models/product_model.dart';
import '../utils/product_variants.dart';

sealed class ProductDetailsState {
  const ProductDetailsState();
}

class ProductDetailsInitial extends ProductDetailsState {
  const ProductDetailsInitial();
}

class ProductDetailsLoading extends ProductDetailsState {
  const ProductDetailsLoading();
}

class ProductDetailsError extends ProductDetailsState {
  final String message;

  const ProductDetailsError(this.message);
}

class ProductDetailsLoaded extends ProductDetailsState {
  final ProductModel product;

  final List<ProductModel> relatedProducts;

  final String? selectedSize;
  final ProductColorOption? selectedColor;

  const ProductDetailsLoaded({
    required this.product,
    this.relatedProducts = const [],
    this.selectedSize,
    this.selectedColor,
  });

  bool get isWearable => product.isWearable;

  double get imageScale =>
      selectedSize == null ? 1 : scaleForSize(selectedSize!);

  String? get variantImageUrl {
    final color = selectedColor;
    if (!isWearable || color == null) return null;

    final pixels = (variantBaseSize * imageScale).round();
    return ApiEndpoints.generatedImage(
      width: pixels,
      height: pixels,
      backgroundHex: color.hex,
    );
  }

  ProductDetailsLoaded copyWith({
    List<ProductModel>? relatedProducts,
    String? selectedSize,
    ProductColorOption? selectedColor,
  }) {
    return ProductDetailsLoaded(
      product: product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
    );
  }
}
