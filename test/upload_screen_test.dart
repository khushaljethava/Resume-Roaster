import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_resume_roaster/core/constants/app_strings.dart';
import 'package:ai_resume_roaster/core/theme/app_theme.dart';
import 'package:ai_resume_roaster/main.dart';
import 'package:ai_resume_roaster/presentation/providers/roast_provider.dart';
import 'package:ai_resume_roaster/presentation/screens/upload_screen.dart';

Widget buildTestWidget(Widget child, {RoastProvider? provider}) {
  return RoastProviderScope(
    provider: provider ?? RoastProvider(),
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: child,
    ),
  );
}

void main() {
  group('UploadScreen', () {
    testWidgets('displays upload title', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadScreen()));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(AppStrings.uploadTitle), findsOneWidget);
    });

    testWidgets('displays roast intensity selector', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadScreen()));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(AppStrings.roastIntensity), findsOneWidget);
      expect(find.text('Mild'), findsOneWidget);
      expect(find.text('Medium'), findsOneWidget);
      expect(find.text('Savage'), findsOneWidget);
    });

    testWidgets('shows file picker area', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadScreen()));
      await tester.pump(const Duration(seconds: 1));

      expect(find.text(AppStrings.selectPdf), findsOneWidget);
    });

    testWidgets('does not show ignite button without file', (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadScreen()));
      await tester.pump(const Duration(seconds: 1));

      expect(find.textContaining(AppStrings.ignite), findsNothing);
    });

    testWidgets('intensity selector displays all three options',
        (tester) async {
      await tester.pumpWidget(buildTestWidget(const UploadScreen()));
      await tester.pump(const Duration(seconds: 1));

      // Verify descriptions are shown
      expect(find.text('Constructive feedback with light teasing'),
          findsOneWidget);
      expect(find.text('Balanced roast with real talk'), findsOneWidget);
      expect(find.text('No mercy. Pure brutality.'), findsOneWidget);
    });
  });
}
