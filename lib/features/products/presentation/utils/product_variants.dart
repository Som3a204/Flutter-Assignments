import 'package:flutter/material.dart';

import '../../data/models/product_model.dart';

const Set<String> wearableCategories = {
  'mens-shirts',
  'mens-shoes',
  'womens-dresses',
  'womens-shoes',
  'tops',
};

extension ProductWearable on ProductModel {
  bool get isWearable => wearableCategories.contains(category);
}

const int variantBaseSize = 400;

const List<String> productSizes = [
  '6',
  '6.5',
  '7',
  '7.5',
  '8',
  '8.5',
  '9',
  '9.5',
  '10',
];

const String kDefaultSize = '7';

/// How big the product appears for [size]: the smallest size renders at 70 %,
/// the largest at 100 %, evenly spaced in between.
double scaleForSize(String size) {
  final index = productSizes.indexOf(size);
  if (index < 0) return 1;
  return 0.7 + 0.3 * index / (productSizes.length - 1);
}

class ProductColorOption {
  final String name;
  final String hex;

  const ProductColorOption(this.name, this.hex);

  Color get color => Color(int.parse('FF$hex', radix: 16));
}

const List<ProductColorOption> kProductColors = [
  ProductColorOption('Yellow', 'FFC833'),
  ProductColorOption('Blue', '40BFFF'),
  ProductColorOption('Pink', 'FB7181'),
  ProductColorOption('Green', '53D1B6'),
  ProductColorOption('Indigo', '5C61F4'),
  ProductColorOption('Navy', '223263'),
];
