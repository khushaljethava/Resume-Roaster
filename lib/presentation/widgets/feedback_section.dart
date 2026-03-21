import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/roast_result.dart';

class FeedbackSection extends StatefulWidget {
  final ConstructiveFeedback feedback;

  const FeedbackSection({super.key, required this.feedback});

  @override
  State<FeedbackSection> createState() => _FeedbackSectionState();
}

class _FeedbackSectionState extends State<FeedbackSection> {
  bool _expanded = false;

  String _buildMarkdown() {
    final buffer = StringBuffer();

    buffer.writeln('## \u{2705} What\'s Working\n');
    for (final point in widget.feedback.whatsWorking) {
      buffer.writeln('- $point');
    }

    buffer.writeln('\n## \u{274C} What Needs Fixing\n');
    for (final point in widget.feedback.needsFixing) {
      buffer.writeln('- $point');
    }

    buffer.writeln('\n## \u{1F680} Top 3 Quick Wins\n');
    for (int i = 0; i < widget.feedback.quickWins.length; i++) {
      buffer.writeln('${i + 1}. ${widget.feedback.quickWins[i]}');
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('\u{1F4A1}', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Okay, but actually...',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: MarkdownBody(
                data: _buildMarkdown(),
                styleSheet: MarkdownStyleSheet(
                  h2: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.accent,
                        fontSize: 16,
                      ),
                  p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        height: 1.5,
                      ),
                  listBullet: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
