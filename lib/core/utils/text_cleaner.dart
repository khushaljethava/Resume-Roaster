class TextCleaner {
  static const int maxLength = 4000;

  static String clean(String text) {
    // Remove excessive whitespace
    var cleaned = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Remove common special/control characters but keep punctuation
    cleaned = cleaned.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'), '');

    // Truncate to max length
    if (cleaned.length > maxLength) {
      cleaned = cleaned.substring(0, maxLength);
    }

    return cleaned;
  }

  static bool isValidResume(String text) {
    return text.trim().length >= 100;
  }
}
