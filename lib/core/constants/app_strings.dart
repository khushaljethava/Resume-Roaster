class AppStrings {
  AppStrings._();

  static const String appName = 'AI Resume Roaster';
  static const String tagline = 'We roast. You improve.';
  static const String readyToGetRoasted = 'Ready to get roasted?';
  static const String roastMyResume = 'Roast My Resume';
  static const String howItWorks = 'How it works';
  static const String resumesRoastedToday = '1,337 resumes roasted today';
  static const String hallOfShame = 'Hall of Shame';

  static const String uploadTitle = 'Upload Your Resume';
  static const String uploadSubtitle = 'Drop your PDF and prepare to be judged';
  static const String roastIntensity = 'Roast Intensity';
  static const String ignite = 'IGNITE';
  static const String selectPdf = 'Tap to select a PDF';

  static const String intensityMild = 'Mild';
  static const String intensityMildDesc = 'Constructive feedback with light teasing';
  static const String intensityMedium = 'Medium';
  static const String intensityMediumDesc = 'Balanced roast with real talk';
  static const String intensitySavage = 'Savage';
  static const String intensitySavageDesc = 'No mercy. Pure brutality.';

  static const List<String> loadingMessages = [
    'Summoning the roast demons...',
    'Judging your life choices...',
    'Calling your old boss for receipts...',
    'Calculating your LinkedIn delusion score...',
    'Laughing at your objective statement...',
    "Filing this under 'yikes'...",
    'Warming up the roast pit...',
    'Consulting the career gods...',
  ];

  static const String shareTemplate =
      "I just got roasted by AI \u{1F525} My resume scored {score}/100. "
      "Top roast: '{roast}' \u{2014} Try AI Resume Roaster!";

  static const String errorGeneric = 'Even our AI refused to read this resume.';
  static const String errorNoText =
      'This PDF is image-based. Please use a text-based PDF.';
  static const String errorTooShort =
      'Your resume seems too short. Please upload a more complete resume.';
  static const String errorOnlyPdf = 'Only PDFs are supported';
  static const String errorNoApiKey =
      'API key not configured. Add your API key to the .env file.';
  static const String errorOffline =
      'No internet connection. Please check your network and try again.';

  static String scoreVerdict(int score) {
    if (score <= 40) return "\u{1F480} You're cooked";
    if (score <= 70) return '\u{1F975} Sweating bullets';
    if (score <= 90) return '\u{1F605} Not bad, not great';
    return '\u{1F60E} Surprisingly decent';
  }
}
