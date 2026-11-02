import '../../data/models/product_rating_model.dart';
import '../view_models/ratings_cubit.dart';

/// Data handed to the add/edit rating route through go_router's `extra`.
///
/// The form must update the *same* [RatingsCubit] as the list underneath it,
/// so the cubit travels with the navigation. `extra` only lives in memory: if
/// it is missing (e.g. after a web refresh) the router falls back to the
/// ratings list.
class RatingFormArgs {
  final RatingsCubit cubit;

  /// Set when editing an existing rating; `null` when adding a new one.
  final ProductRatingModel? rating;
  final String? reviewerName;
  final String? reviewerEmail;

  const RatingFormArgs({
    required this.cubit,
    this.rating,
    this.reviewerName,
    this.reviewerEmail,
  });
}
