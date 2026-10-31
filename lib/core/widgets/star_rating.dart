import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final int maxStars;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 16,
    this.maxStars = 5,
  });

  @override
  Widget build(BuildContext context) {
    final filled = rating.round();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        maxStars,
        (index) => Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            Icons.star,
            size: size,
            color: index < filled ? AppColors.star : AppColors.border,
          ),
        ),
      ),
    );
  }
}
