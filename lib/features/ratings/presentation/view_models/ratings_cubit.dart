import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../products/data/repositories/products_repository.dart';
import '../../data/models/product_rating_model.dart';
import '../../data/repositories/ratings_repository.dart';
import 'ratings_state.dart';

/// Cubit to manage product ratings: the user's own reviews (local SQLite)
/// plus the customer reviews that come with the product from the API.
class RatingsCubit extends Cubit<RatingsState> {
  final RatingsRepository repository;
  final ProductsRepository productsRepository;
  final int productId;

  RatingsCubit({
    required this.repository,
    required this.productsRepository,
    required this.productId,
  }) : super(const RatingsInitial());

  // API reviews don't change while the screen is open, so they are fetched
  // once and reused when the user adds, edits or deletes a review. A failed
  // fetch is retried on the next load.
  List<ProductRatingModel> _customerReviews = const [];
  bool _customerReviewsLoaded = false;
  bool _customerReviewsFailed = false;

  Future<void> loadRatings() async {
    emit(const RatingsLoading());
    try {
      await _ensureCustomerReviews();
      final ratings = await repository.getRatings(productId);
      emit(_buildLoaded(ratings));
    } catch (e) {
      emit(RatingsError(message: e.toString()));
    }
  }

  /// Loads the product's API reviews. Never throws: if the request fails the
  /// screen still shows the user's own reviews, with a retry notice.
  Future<void> _ensureCustomerReviews() async {
    if (_customerReviewsLoaded) return;
    try {
      final product = await productsRepository.getProductById(productId);
      _customerReviews = [
        for (final review in product.reviews)
          ProductRatingModel.fromApiReview(review, productId: productId),
      ];
      _customerReviewsLoaded = true;
      _customerReviewsFailed = false;
    } catch (_) {
      _customerReviewsFailed = true;
    }
  }

  RatingsLoaded _buildLoaded(List<ProductRatingModel> ratings) {
    final all = [..._customerReviews, ...ratings];
    final sum = all.fold<int>(0, (total, item) => total + item.rating);

    return RatingsLoaded(
      ratings: ratings,
      customerReviews: _customerReviews,
      customerReviewsFailed: _customerReviewsFailed,
      averageRating: all.isEmpty ? 0.0 : sum / all.length,
      ratingCount: all.length,
    );
  }

  Future<void> addRating(ProductRatingModel rating) async {
    try {
      final cached = await _cachePhoto(rating);
      await repository.addRating(cached);
      await loadRatings();
    } catch (e) {
      emit(RatingsError(message: e.toString()));
    }
  }

  Future<void> updateRating(
    ProductRatingModel rating, {
    String? previousPhotoPath,
  }) async {
    try {
      final cached = await _cachePhoto(rating);
      await repository.updateRating(cached);
      if (previousPhotoPath != null &&
          previousPhotoPath != cached.photoPath) {
        await repository.deletePhoto(previousPhotoPath);
      }
      await loadRatings();
    } catch (e) {
      emit(RatingsError(message: e.toString()));
    }
  }

  /// Copies a picked photo into the app-local cache, preserving [photoPath]
  /// when it already points to a cached/kept file.
  Future<ProductRatingModel> _cachePhoto(ProductRatingModel rating) async {
    final path = rating.photoPath;
    if (path == null || path.isEmpty) return rating;
    final cached = await repository.cachePhoto(path);
    return rating.copyWith(photoPath: cached);
  }

  Future<void> deleteRating(int id) async {
    try {
      await repository.deleteRating(id);
      await loadRatings();
    } catch (e) {
      emit(RatingsError(message: e.toString()));
    }
  }
}
