class ProductModel {
  final String id;
  final String name;
  final double price;
  final double discountPrice;
  final double rating;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discountPrice,
    required this.rating,
    required this.imageUrl,
  });
}
