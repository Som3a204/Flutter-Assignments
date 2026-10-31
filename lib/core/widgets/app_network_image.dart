import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class AppNetworkImage extends StatelessWidget {
  final String? url;
  final BoxFit fit;
  final bool showLoader;
  final bool gaplessPlayback;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.showLoader = true,
    this.gaplessPlayback = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) return const _ImagePlaceholder();

    return Image.network(
      imageUrl,
      width: double.infinity,
      fit: fit,
      gaplessPlayback: gaplessPlayback,
      loadingBuilder: showLoader
          ? (context, child, progress) {
              if (progress == null) return child;
              return const _ImagePlaceholder(showLoader: true);
            }
          : null,
      errorBuilder: (context, error, stackTrace) => const _ImagePlaceholder(),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  final bool showLoader;

  const _ImagePlaceholder({this.showLoader = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      child: Center(
        child: showLoader
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              )
            : const Icon(Icons.image, size: 50, color: AppColors.border),
      ),
    );
  }
}
