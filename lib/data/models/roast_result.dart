class RoastResult {
  final int overallScore;
  final String scoreVerdict;
  final List<RoastLine> roastLines;
  final Map<String, CategoryScore> categoryScores;
  final ConstructiveFeedback constructiveFeedback;
  final DateTime timestamp;

  RoastResult({
    required this.overallScore,
    required this.scoreVerdict,
    required this.roastLines,
    required this.categoryScores,
    required this.constructiveFeedback,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory RoastResult.fromJson(Map<String, dynamic> json) {
    return RoastResult(
      overallScore: (json['overall_score'] as num).toInt(),
      scoreVerdict: json['score_verdict'] as String,
      roastLines: (json['roast_lines'] as List)
          .map((e) => RoastLine.fromJson(e as Map<String, dynamic>))
          .toList(),
      categoryScores: (json['category_scores'] as Map<String, dynamic>).map(
        (key, value) =>
            MapEntry(key, CategoryScore.fromJson(value as Map<String, dynamic>)),
      ),
      constructiveFeedback: ConstructiveFeedback.fromJson(
          json['constructive_feedback'] as Map<String, dynamic>),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall_score': overallScore,
      'score_verdict': scoreVerdict,
      'roast_lines': roastLines.map((e) => e.toJson()).toList(),
      'category_scores':
          categoryScores.map((key, value) => MapEntry(key, value.toJson())),
      'constructive_feedback': constructiveFeedback.toJson(),
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

class RoastLine {
  final String line;
  final String category;
  final String emoji;

  RoastLine({
    required this.line,
    required this.category,
    required this.emoji,
  });

  factory RoastLine.fromJson(Map<String, dynamic> json) {
    return RoastLine(
      line: json['line'] as String,
      category: json['category'] as String,
      emoji: json['emoji'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'line': line,
      'category': category,
      'emoji': emoji,
    };
  }
}

class CategoryScore {
  final int score;
  final String verdict;

  CategoryScore({
    required this.score,
    required this.verdict,
  });

  factory CategoryScore.fromJson(Map<String, dynamic> json) {
    return CategoryScore(
      score: (json['score'] as num).toInt(),
      verdict: json['verdict'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'verdict': verdict,
    };
  }
}

class ConstructiveFeedback {
  final List<String> whatsWorking;
  final List<String> needsFixing;
  final List<String> quickWins;

  ConstructiveFeedback({
    required this.whatsWorking,
    required this.needsFixing,
    required this.quickWins,
  });

  factory ConstructiveFeedback.fromJson(Map<String, dynamic> json) {
    return ConstructiveFeedback(
      whatsWorking: List<String>.from(json['whats_working'] as List),
      needsFixing: List<String>.from(json['needs_fixing'] as List),
      quickWins: List<String>.from(json['quick_wins'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'whats_working': whatsWorking,
      'needs_fixing': needsFixing,
      'quick_wins': quickWins,
    };
  }
}
