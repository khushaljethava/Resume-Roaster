import 'package:flutter_test/flutter_test.dart';
import 'package:ai_resume_roaster/core/utils/text_cleaner.dart';

void main() {
  group('TextCleaner', () {
    test('removes excessive whitespace', () {
      final result = TextCleaner.clean('Hello    World\n\n\nTest');
      expect(result, 'Hello World Test');
    });

    test('removes control characters', () {
      final result = TextCleaner.clean('Hello\x00World\x01Test');
      expect(result, 'HelloWorldTest');
    });

    test('truncates to max length', () {
      final longText = 'A' * 5000;
      final result = TextCleaner.clean(longText);
      expect(result.length, TextCleaner.maxLength);
    });

    test('preserves normal punctuation', () {
      final result = TextCleaner.clean('Hello, World! How are you?');
      expect(result, 'Hello, World! How are you?');
    });

    test('trims whitespace', () {
      final result = TextCleaner.clean('  Hello World  ');
      expect(result, 'Hello World');
    });
  });

  group('TextCleaner.isValidResume', () {
    test('returns false for short text', () {
      expect(TextCleaner.isValidResume('short'), false);
    });

    test('returns false for empty text', () {
      expect(TextCleaner.isValidResume(''), false);
    });

    test('returns true for text >= 100 chars', () {
      final text = 'A' * 100;
      expect(TextCleaner.isValidResume(text), true);
    });

    test('returns false for whitespace-only text under 100 chars', () {
      expect(TextCleaner.isValidResume('   '), false);
    });
  });
}
