import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'text_cleaner.dart';

class PdfExtractor {
  Future<String> extractTextFromPdf(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw Exception('File not found: $filePath');
    }

    final bytes = await file.readAsBytes();
    final PdfDocument document = PdfDocument(inputBytes: bytes);

    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < document.pages.count; i++) {
      final String pageText =
          PdfTextExtractor(document).extractText(startPageIndex: i);
      buffer.writeln(pageText);
    }

    document.dispose();

    final rawText = buffer.toString();
    if (rawText.trim().isEmpty) {
      throw Exception(
          'No extractable text found. This PDF may be image-based.');
    }

    return TextCleaner.clean(rawText);
  }
}
