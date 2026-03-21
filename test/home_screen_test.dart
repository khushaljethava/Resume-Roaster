import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_resume_roaster/core/constants/app_strings.dart';
import 'package:ai_resume_roaster/core/theme/app_theme.dart';
import 'package:ai_resume_roaster/main.dart';
import 'package:ai_resume_roaster/presentation/providers/roast_provider.dart';
import 'package:ai_resume_roaster/presentation/screens/home_screen.dart';

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
  group('HomeScreen', () {
    testWidgets('displays title text', (tester) async {
      await tester.pumpWidget(buildTestWidget(const HomeScreen()));
      // Use pump with duration instead of pumpAndSettle (looping animations)
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(AppStrings.readyToGetRoasted), findsOneWidget);
    });

    testWidgets('displays roast my resume button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const HomeScreen()));
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining(AppStrings.roastMyResume),
        findsOneWidget,
      );
    });

    testWidgets('displays how it works button', (tester) async {
      await tester.pumpWidget(buildTestWidget(const HomeScreen()));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(AppStrings.howItWorks), findsOneWidget);
    });

    testWidgets('displays stats section', (tester) async {
      await tester.pumpWidget(buildTestWidget(const HomeScreen()));
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.textContaining('1,337'),
        findsOneWidget,
      );
    });
  });
}
