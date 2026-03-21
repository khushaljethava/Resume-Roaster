import 'package:flutter_test/flutter_test.dart';
import 'package:ai_resume_roaster/data/models/roast_result.dart';

void main() {
  group('RoastResult.fromJson', () {
    final sampleJson = {
      'overall_score': 72,
      'score_verdict': 'Not terrible, but not great either',
      'roast_lines': [
        {
          'line': 'Your objective statement is longer than your experience',
          'category': 'Objective',
          'emoji': '\u{1F480}',
        },
        {
          'line': 'Microsoft Word is not a skill in 2024',
          'category': 'Skills',
          'emoji': '\u{1F602}',
        },
      ],
      'category_scores': {
        'writing_quality': {'score': 7, 'verdict': 'Decent grammar at least'},
        'relevance_clarity': {
          'score': 5,
          'verdict': 'What are you even applying for?'
        },
        'experience_presentation': {
          'score': 6,
          'verdict': 'Could use more numbers'
        },
        'skills_section': {
          'score': 4,
          'verdict': 'Half of these are not skills'
        },
        'formatting_design': {
          'score': 8,
          'verdict': 'At least it looks nice'
        },
      },
      'constructive_feedback': {
        'whats_working': [
          'Clean layout',
          'Good use of action verbs',
        ],
        'needs_fixing': [
          'Remove the objective statement',
          'Add quantified achievements',
          'Update your skills list',
        ],
        'quick_wins': [
          'Add 3 bullet points with metrics',
          'Remove Microsoft Office from skills',
          'Add a professional summary instead of objective',
        ],
      },
    };

    test('parses overall score correctly', () {
      final result = RoastResult.fromJson(sampleJson);
      expect(result.overallScore, 72);
    });

    test('parses score verdict correctly', () {
      final result = RoastResult.fromJson(sampleJson);
      expect(result.scoreVerdict, 'Not terrible, but not great either');
    });

    test('parses roast lines correctly', () {
      final result = RoastResult.fromJson(sampleJson);
      expect(result.roastLines.length, 2);
      expect(result.roastLines[0].category, 'Objective');
      expect(result.roastLines[1].line,
          'Microsoft Word is not a skill in 2024');
    });

    test('parses category scores correctly', () {
      final result = RoastResult.fromJson(sampleJson);
      expect(result.categoryScores.length, 5);
      expect(result.categoryScores['writing_quality']?.score, 7);
      expect(result.categoryScores['skills_section']?.verdict,
          'Half of these are not skills');
    });

    test('parses constructive feedback correctly', () {
      final result = RoastResult.fromJson(sampleJson);
      expect(result.constructiveFeedback.whatsWorking.length, 2);
      expect(result.constructiveFeedback.needsFixing.length, 3);
      expect(result.constructiveFeedback.quickWins.length, 3);
    });

    test('roundtrip toJson/fromJson preserves data', () {
      final original = RoastResult.fromJson(sampleJson);
      final json = original.toJson();
      final roundtripped = RoastResult.fromJson(json);

      expect(roundtripped.overallScore, original.overallScore);
      expect(roundtripped.scoreVerdict, original.scoreVerdict);
      expect(roundtripped.roastLines.length, original.roastLines.length);
      expect(roundtripped.roastLines[0].line, original.roastLines[0].line);
      expect(roundtripped.categoryScores.length,
          original.categoryScores.length);
      expect(
          roundtripped.constructiveFeedback.quickWins.length,
          original.constructiveFeedback.quickWins.length);
    });
  });

  group('RoastLine', () {
    test('fromJson creates correct instance', () {
      final line = RoastLine.fromJson({
        'line': 'Test roast',
        'category': 'Skills',
        'emoji': '\u{1F525}',
      });
      expect(line.line, 'Test roast');
      expect(line.category, 'Skills');
      expect(line.emoji, '\u{1F525}');
    });
  });

  group('ConstructiveFeedback', () {
    test('fromJson creates correct instance', () {
      final feedback = ConstructiveFeedback.fromJson({
        'whats_working': ['Point A'],
        'needs_fixing': ['Point B', 'Point C'],
        'quick_wins': ['Win 1'],
      });
      expect(feedback.whatsWorking, ['Point A']);
      expect(feedback.needsFixing.length, 2);
      expect(feedback.quickWins.first, 'Win 1');
    });
  });
}
