class GeminiPrompts {
  GeminiPrompts._();

  static const String systemInstruction = '''
You are "The Roastmaster", an AI resume critic who combines brutal humor with genuine career advice. You roast resumes like a comedy roast — savage, specific, and funny — but always back it up with actionable feedback. You do NOT hold back on the roasting, but you always want the person to actually improve.
''';

  static String buildUserPrompt(String resumeText, String intensity) {
    return '''
Here is a resume to roast at intensity level: $intensity

RESUME CONTENT:
$resumeText

Respond ONLY with a valid JSON object in this exact structure (no markdown code blocks, no extra text):

{
  "overall_score": <integer 0-100>,
  "score_verdict": "<one line funny verdict>",
  "roast_lines": [
    {"line": "<roast joke>", "category": "<Skills|Experience|Format|Objective|Education>", "emoji": "<single emoji>"},
    {"line": "<roast joke>", "category": "<Skills|Experience|Format|Objective|Education>", "emoji": "<single emoji>"},
    {"line": "<roast joke>", "category": "<Skills|Experience|Format|Objective|Education>", "emoji": "<single emoji>"},
    {"line": "<roast joke>", "category": "<Skills|Experience|Format|Objective|Education>", "emoji": "<single emoji>"},
    {"line": "<roast joke>", "category": "<Skills|Experience|Format|Objective|Education>", "emoji": "<single emoji>"},
    {"line": "<roast joke>", "category": "<Skills|Experience|Format|Objective|Education>", "emoji": "<single emoji>"}
  ],
  "category_scores": {
    "writing_quality": {"score": <1-10>, "verdict": "<one line>"},
    "relevance_clarity": {"score": <1-10>, "verdict": "<one line>"},
    "experience_presentation": {"score": <1-10>, "verdict": "<one line>"},
    "skills_section": {"score": <1-10>, "verdict": "<one line>"},
    "formatting_design": {"score": <1-10>, "verdict": "<one line>"}
  },
  "constructive_feedback": {
    "whats_working": ["<point 1>", "<point 2>"],
    "needs_fixing": ["<point 1>", "<point 2>", "<point 3>"],
    "quick_wins": ["<actionable tip 1>", "<actionable tip 2>", "<actionable tip 3>"]
  }
}
''';
  }
}
