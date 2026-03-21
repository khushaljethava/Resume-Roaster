import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final int score;
  final String verdict;

  const CategoryChip({
    super.key,
    required this.label,
    required this.score,
    required this.verdict,
  });

  Color get _barColor {
    if (score <= 3) return AppColors.scoreRed;
    if (score <= 5) return AppColors.scoreOrange;
    if (score <= 7) return AppColors.scoreYellow;
    return AppColors.scoreGreen;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '$score/10',
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: _barColor),
                semanticsLabel: '$label score: $score out of 10',
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 10,
              minHeight: 6,
              backgroundColor: AppColors.surface,
              valueColor: AlwaysStoppedAnimation<Color>(_barColor),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            verdict,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
