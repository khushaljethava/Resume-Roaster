import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:confetti/confetti.dart';
import 'package:share_plus/share_plus.dart' show Share;
import '../../core/constants/app_colors.dart';
import '../../data/models/roast_result.dart';
import '../../data/models/resume_score.dart';
import '../../main.dart';
import '../widgets/score_gauge.dart';
import '../widgets/roast_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/feedback_section.dart';
import 'upload_screen.dart';

class ResultsScreen extends StatefulWidget {
  final RoastResult result;

  const ResultsScreen({super.key, required this.result});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    if (widget.result.overallScore > 85) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final score = ResumeScore(widget.result.overallScore);

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  // Section A: Overall Score
                  _buildScoreSection(context, score),
                  const SizedBox(height: 32),
                  // Section B: Roast Cards
                  _buildRoastCardsSection(context),
                  const SizedBox(height: 32),
                  // Section C: Category Breakdown
                  _buildCategorySection(context),
                  const SizedBox(height: 32),
                  // Section D: Constructive Feedback
                  FeedbackSection(
                      feedback: widget.result.constructiveFeedback),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ),
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.primary,
                AppColors.secondary,
                AppColors.accent,
                Colors.red,
                Colors.orange,
              ],
            ),
          ),
          // Section E: Bottom Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreSection(BuildContext context, ResumeScore score) {
    return Column(
      children: [
        ScoreGauge(
          score: widget.result.overallScore,
          color: score.color,
        ).animate().fadeIn(duration: 600.ms).scale(
              begin: const Offset(0.5, 0.5),
              end: const Offset(1, 1),
              duration: 800.ms,
              curve: Curves.elasticOut,
            ),
        const SizedBox(height: 16),
        Text(
          '${score.emoji} ${widget.result.scoreVerdict}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: score.color,
              ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildRoastCardsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u{1F525} Roast Cards',
          style: Theme.of(context).textTheme.headlineMedium,
        ).animate().fadeIn(delay: 600.ms),
        const SizedBox(height: 8),
        Text(
          'Swipe right to save, left to dismiss',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: RoastCardStack(roastLines: widget.result.roastLines),
        ).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1, end: 0),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final categories = {
      'writing_quality': '\u{1F4DD} Writing Quality',
      'relevance_clarity': '\u{1F3AF} Relevance & Clarity',
      'experience_presentation': '\u{1F4BC} Experience Presentation',
      'skills_section': '\u{1F6E0}\u{FE0F} Skills Section',
      'formatting_design': '\u{1F3A8} Formatting & Design',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\u{1F4CA} Category Breakdown',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ...categories.entries.map((entry) {
          final catScore = widget.result.categoryScores[entry.key];
          if (catScore == null) return const SizedBox.shrink();
          return CategoryChip(
            label: entry.value,
            score: catScore.score,
            verdict: catScore.verdict,
          );
        }),
      ],
    ).animate().fadeIn(delay: 1000.ms);
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _bottomAction(
              context,
              icon: Icons.share,
              label: 'Share',
              semanticLabel: 'Share roast results',
              onTap: () {
                final provider = RoastProviderScope.read(context);
                Share.share(provider.getShareText());
              },
            ),
            _bottomAction(
              context,
              icon: Icons.refresh,
              label: 'Roast Again',
              semanticLabel: 'Roast another resume',
              onTap: () {
                RoastProviderScope.read(context).reset();
                Navigator.of(context).pushAndRemoveUntil(
                  PageRouteBuilder(
                    pageBuilder: (_, a, b) => const UploadScreen(),
                    transitionsBuilder: (_, animation, a2, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 400),
                  ),
                  (route) => route.isFirst,
                );
              },
            ),
            _bottomAction(
              context,
              icon: Icons.save,
              label: 'Save',
              semanticLabel: 'Save roast result',
              onTap: () async {
                await RoastProviderScope.read(context).saveCurrentResult();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Result saved!'),
                      backgroundColor: AppColors.primary,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String semanticLabel,
    required VoidCallback onTap,
  }) {
    return Semantics(
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
