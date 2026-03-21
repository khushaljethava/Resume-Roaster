import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/constants/app_colors.dart';

class ScoreGauge extends StatefulWidget {
  final int score;
  final Color color;

  const ScoreGauge({
    super.key,
    required this.score,
    required this.color,
  });

  @override
  State<ScoreGauge> createState() => _ScoreGaugeState();
}

class _ScoreGaugeState extends State<ScoreGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scoreAnimation = IntTween(begin: 0, end: widget.score).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, _) {
        return CircularPercentIndicator(
          radius: 80,
          lineWidth: 12,
          percent: _scoreAnimation.value / 100,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${_scoreAnimation.value}',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: widget.color,
                      fontSize: 48,
                    ),
                semanticsLabel: 'Score ${widget.score} out of 100',
              ),
              Text(
                '/ 100',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          progressColor: widget.color,
          backgroundColor: AppColors.surface,
          circularStrokeCap: CircularStrokeCap.round,
          animateFromLastPercent: false,
          animation: false, // We handle animation ourselves
        );
      },
    );
  }
}
