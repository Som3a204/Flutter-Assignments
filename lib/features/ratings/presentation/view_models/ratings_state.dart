import '../../data/models/product_rating_model.dart';

/// States emitted by [RatingsCubit] for product ratings.
sealed class RatingsState {
  const RatingsState();
}

/// Initial state before any load has been triggered.
class RatingsInitial extends RatingsState {
  const RatingsInitial();
}

/// A load is in progress.
class RatingsLoading extends RatingsState {
  const RatingsLoading();
}

/// Ratings loaded successfully.
class RatingsLoaded extends RatingsState {
  /// Reviews the user wrote on this device (editable, newest first).
  final List<ProductRatingModel> ratings;

  /// Customer reviews that came with the product from the API (read-only).
  final List<ProductRatingModel> customerReviews;

  /// `true` when the API reviews could not be loaded. [ratings] is still
  /// valid; the screen shows a notice with a retry action.
  final bool customerReviewsFailed;

  /// Average and count over [customerReviews] and [ratings] together.
  final double averageRating;
  final int ratingCount;

  const RatingsLoaded({
    required this.ratings,
    required this.averageRating,
    required this.ratingCount,
    this.customerReviews = const [],
    this.customerReviewsFailed = false,
  });
}

/// Loading or saving ratings failed. [message] is safe to show to the user.
class RatingsError extends RatingsState {
  final String message;

  const RatingsError({required this.message});
}
