import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/responsive/responsive_context.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Dark promo banner with a title and a live countdown.
///
/// Uses a gradient as its background. To use a photo instead, wrap the
/// content in a `DecorationImage` (with a dark overlay) in `decoration`.
class FlashSaleBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final Duration remaining;

  const FlashSaleBanner({
    super.key,
    required this.title,
    required this.subtitle,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.responsive(mobile: 206.0, tablet: 240.0),
      padding: EdgeInsets.all(context.spacing.lg),
      decoration: BoxDecoration(
        borderRadius: AppRadius.card,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF8B1E2D)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$title\n$subtitle',
            style: context.textStyles.heading2.copyWith(color: Colors.white),
          ),
          FlashSaleCountdown(initial: remaining),
        ],
      ),
    );
  }
}

/// `HH : MM : SS` boxes that tick down once per second until zero.
class FlashSaleCountdown extends StatefulWidget {
  final Duration initial;

  const FlashSaleCountdown({super.key, required this.initial});

  @override
  State<FlashSaleCountdown> createState() => _FlashSaleCountdownState();
}

class _FlashSaleCountdownState extends State<FlashSaleCountdown> {
  late Duration _remaining = widget.initial;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining.inSeconds <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _remaining -= const Duration(seconds: 1));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _TimeBox(value: _remaining.inHours),
        const _Separator(),
        _TimeBox(value: _remaining.inMinutes.remainder(60)),
        const _Separator(),
        _TimeBox(value: _remaining.inSeconds.remainder(60)),
      ],
    );
  }
}

class _TimeBox extends StatelessWidget {
  final int value;

  const _TimeBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        value.toString().padLeft(2, '0'),
        style: context.textStyles.heading4
            .copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        ':',
        style: context.textStyles.heading4.copyWith(color: Colors.white),
      ),
    );
  }
}
