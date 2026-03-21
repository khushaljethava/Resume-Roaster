import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ResumeScore {
  final int score;

  ResumeScore(this.score);

  Color get color {
    if (score <= 40) return AppColors.scoreRed;
    if (score <= 70) return AppColors.scoreOrange;
    if (score <= 90) return AppColors.scoreYellow;
    return AppColors.scoreGreen;
  }

  String get emoji {
    if (score <= 40) return '\u{1F480}';
    if (score <= 70) return '\u{1F975}';
    if (score <= 90) return '\u{1F605}';
    return '\u{1F60E}';
  }

  String get label {
    if (score <= 40) return "You're cooked";
    if (score <= 70) return 'Sweating bullets';
    if (score <= 90) return 'Not bad, not great';
    return 'Surprisingly decent';
  }
}
