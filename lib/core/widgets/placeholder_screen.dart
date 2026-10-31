import 'package:flutter/material.dart';

import '../responsive/responsive_context.dart';
import '../theme/app_colors.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 56, color: AppColors.primary),
              SizedBox(height: context.spacing.md),
              Text(title, style: context.textStyles.heading3),
              SizedBox(height: context.spacing.xs),
              Text('Coming soon', style: context.textStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}
