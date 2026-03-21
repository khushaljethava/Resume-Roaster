import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_resume_roaster/core/theme/app_theme.dart';
import 'package:ai_resume_roaster/data/models/roast_result.dart';
import 'package:ai_resume_roaster/main.dart';
import 'package:ai_resume_roaster/presentation/providers/roast_provider.dart';
import 'package:ai_resume_roaster/presentation/screens/results_screen.dart';

final _testResult = RoastResult(
  overallScore: 65,
  scoreVerdict: 'Mediocre at best',
  roastLines: [
    RoastLine(
        line: 'Your resume is a masterclass in mediocrity',
        category: 'Format',
        emoji: '\u{1F602}'),
    RoastLine(
        line: 'Skills: breathing, existing',
        category: 'Skills',
        emoji: '\u{1F480}'),
  ],
  categoryScores: {
    'writing_quality': CategoryScore(score: 7, verdict: 'Not bad'),
    'relevance_clarity': CategoryScore(score: 5, verdict: 'Meh'),
    'experience_presentation':
        CategoryScore(score: 6, verdict: 'Needs work'),
    'skills_section': CategoryScore(score: 4, verdict: 'Yikes'),
    'formatting_design': CategoryScore(score: 8, verdict: 'Pretty'),
  },
  constructiveFeedback: ConstructiveFeedback(
    whatsWorking: ['Clean layout'],
    needsFixing: ['Add metrics', 'Fix formatting'],
    quickWins: ['Add numbers', 'Shorten summary', 'Update skills'],
  ),
);

Widget buildTestWidget(Widget child) {
  return RoastProviderScope(
    provider: RoastProvider(),
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: child,
    ),
  );
}

void main() {
  group('ResultsScreen', () {
    testWidgets('displays score verdict', (tester) async {
      await tester.pumpWidget(
          buildTestWidget(ResultsScreen(result: _testResult)));
      // Use pump with duration - score animation takes 1.5s
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('Mediocre at best'), findsOneWidget);
    });

    testWidgets('displays category breakdown section', (tester) async {
      await tester.pumpWidget(
          buildTestWidget(ResultsScreen(result: _testResult)));
      await tester.pump(const Duration(seconds: 2));

      expect(find.textContaining('Category Breakdown'), findsOneWidget);
    });

    testWidgets('displays feedback section', (tester) async {
      await tester.pumpWidget(
          buildTestWidget(ResultsScreen(result: _testResult)));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Okay, but actually...'), findsOneWidget);
    });

    testWidgets('displays bottom action buttons', (tester) async {
      await tester.pumpWidget(
          buildTestWidget(ResultsScreen(result: _testResult)));
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('Share'), findsOneWidget);
      expect(find.text('Roast Again'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });
  });
}
