import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../data/models/product_model.dart';

class ProductReviewsSection extends StatefulWidget {
  final double rating;
  final List<ProductReview> reviews;

  const ProductReviewsSection({
    super.key,
    required this.rating,
    required this.reviews,
  });

  @override
  State<ProductReviewsSection> createState() => _ProductReviewsSectionState();
}

class _ProductReviewsSectionState extends State<ProductReviewsSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final reviews = widget.reviews;
    final visible = _showAll ? reviews : reviews.take(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Review Product', style: context.textStyles.heading4),
            if (reviews.length > 1)
              GestureDetector(
                onTap: () => setState(() => _showAll = !_showAll),
                child: Text(
                  _showAll ? 'See Less' : 'See More',
                  style: context.textStyles.title
                      .copyWith(color: AppColors.primary),
                ),
              ),
          ],
        ),
        SizedBox(height: context.spacing.xs),
        Row(
          children: [
            StarRating(rating: widget.rating),
            SizedBox(width: context.spacing.sm),
            Text(
              widget.rating.toStringAsFixed(1),
              style: context.textStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              ' (${reviews.length} ${reviews.length == 1 ? 'Review' : 'Reviews'})',
              style: context.textStyles.caption,
            ),
          ],
        ),
        SizedBox(height: context.spacing.md),
        if (reviews.isEmpty)
          Text('No reviews yet.', style: context.textStyles.body)
        else
          for (final review in visible) _ReviewTile(review: review),
      ],
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ProductReview review;

  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.border,
                child: Text(
                  _initials(review.reviewerName),
                  style: context.textStyles.title
                      .copyWith(color: AppColors.primary),
                ),
              ),
              SizedBox(width: context.spacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: context.textStyles.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.spacing.xs),
                    StarRating(rating: review.rating.toDouble(), size: 14),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          Text(
            review.comment,
            style: context.textStyles.body.copyWith(height: 1.7),
          ),
          if (review.date != null) ...[
            SizedBox(height: context.spacing.sm),
            Text(_formatDate(review.date!), style: context.textStyles.caption),
          ],
        ],
      ),
    );
  }

  static String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    final last = parts.length > 1 ? parts.last[0] : '';
    return (parts.first[0] + last).toUpperCase();
  }

  static String _formatDate(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December',
    ];
    final local = date.toLocal();
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }
}
