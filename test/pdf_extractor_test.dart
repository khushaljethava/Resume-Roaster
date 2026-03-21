import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:ai_resume_roaster/core/utils/pdf_extractor.dart';

void main() {
  group('PdfExtractor', () {
    late PdfExtractor extractor;

    setUp(() {
      extractor = PdfExtractor();
    });

    test('throws exception for non-existent file', () async {
      expect(
        () => extractor.extractTextFromPdf('/nonexistent/path.pdf'),
        throwsException,
      );
    });

    test('extracts text from a valid PDF', () async {
      // Create a simple test PDF in memory and save to temp file
      final document = PdfDocument();
      final page = document.pages.add();
      page.graphics.drawString(
        'John Doe - Software Engineer with 5 years of experience in Flutter and Dart development. '
        'Skilled in mobile app development, REST APIs, and cloud services.',
        PdfStandardFont(PdfFontFamily.helvetica, 12),
      );
      final bytes = document.saveSync();
      document.dispose();

      final tempDir = Directory.systemTemp;
      final tempFile = File('${tempDir.path}/test_resume.pdf');
      await tempFile.writeAsBytes(bytes);

      try {
        final text = await extractor.extractTextFromPdf(tempFile.path);
        expect(text.isNotEmpty, true);
        expect(text.contains('John Doe'), true);
      } finally {
        await tempFile.delete();
      }
    });
  });
}
