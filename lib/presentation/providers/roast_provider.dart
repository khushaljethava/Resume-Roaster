import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/utils/pdf_extractor.dart';
import '../../core/utils/text_cleaner.dart';
import '../../data/models/roast_result.dart';
import '../../data/services/gemini_service.dart';

enum RoastIntensity { mild, medium, savage }

extension RoastIntensityExtension on RoastIntensity {
  String get label {
    switch (this) {
      case RoastIntensity.mild:
        return 'Mild';
      case RoastIntensity.medium:
        return 'Medium';
      case RoastIntensity.savage:
        return 'Savage';
    }
  }

  String get emoji {
    switch (this) {
      case RoastIntensity.mild:
        return '\u{1F336}\u{FE0F}';
      case RoastIntensity.medium:
        return '\u{1F336}\u{FE0F}\u{1F336}\u{FE0F}';
      case RoastIntensity.savage:
        return '\u{1F336}\u{FE0F}\u{1F336}\u{FE0F}\u{1F336}\u{FE0F}';
    }
  }

  String get description {
    switch (this) {
      case RoastIntensity.mild:
        return 'Constructive feedback with light teasing';
      case RoastIntensity.medium:
        return 'Balanced roast with real talk';
      case RoastIntensity.savage:
        return 'No mercy. Pure brutality.';
    }
  }
}

class RoastProvider extends ChangeNotifier {
  final GeminiService _geminiService = GeminiService();
  final PdfExtractor _pdfExtractor = PdfExtractor();

  RoastResult? _result;
  RoastResult? get result => _result;

  String? _selectedFilePath;
  String? get selectedFilePath => _selectedFilePath;

  String? _selectedFileName;
  String? get selectedFileName => _selectedFileName;

  int? _selectedFileSize;
  int? get selectedFileSize => _selectedFileSize;

  RoastIntensity _intensity = RoastIntensity.medium;
  RoastIntensity get intensity => _intensity;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<RoastResult> _history = [];
  List<RoastResult> get history => List.unmodifiable(_history);

  List<RoastLine> _savedRoasts = [];
  List<RoastLine> get savedRoasts => List.unmodifiable(_savedRoasts);

  void setFile(String path, String name, int size) {
    _selectedFilePath = path;
    _selectedFileName = name;
    _selectedFileSize = size;
    _errorMessage = null;
    notifyListeners();
  }

  void clearFile() {
    _selectedFilePath = null;
    _selectedFileName = null;
    _selectedFileSize = null;
    notifyListeners();
  }

  void setIntensity(RoastIntensity intensity) {
    _intensity = intensity;
    notifyListeners();
  }

  void saveRoastLine(RoastLine roast) {
    _savedRoasts.add(roast);
    notifyListeners();
  }

  Future<void> startRoasting() async {
    if (_selectedFilePath == null) {
      _errorMessage = 'No file selected';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _result = null;
    notifyListeners();

    try {
      final resumeText =
          await _pdfExtractor.extractTextFromPdf(_selectedFilePath!);

      if (!TextCleaner.isValidResume(resumeText)) {
        throw Exception(
            'Resume text is too short. Please upload a more complete resume.');
      }

      _result =
          await _geminiService.roastResume(resumeText, _intensity.label);

      // Save to history
      _history.insert(0, _result!);
      if (_history.length > 5) {
        _history = _history.sublist(0, 5);
      }
      await _saveHistory();
    } on SocketException {
      _errorMessage =
          'No internet connection. Please check your network and try again.';
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHistory() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/roast_history.json');
      if (await file.exists()) {
        final content = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(content) as List<dynamic>;
        _history = jsonList
            .map((e) => RoastResult.fromJson(e as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (_) {
      // Silently fail on history load
    }
  }

  Future<void> _saveHistory() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/roast_history.json');
      final jsonList = _history.map((e) => e.toJson()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (_) {
      // Silently fail on history save
    }
  }

  Future<void> saveCurrentResult() async {
    if (_result == null) return;
    await _saveHistory();
  }

  String getShareText() {
    if (_result == null) return '';
    final bestRoast =
        _result!.roastLines.isNotEmpty ? _result!.roastLines.first.line : '';
    return "I just got roasted by AI \u{1F525} My resume scored "
        "${_result!.overallScore}/100. "
        "Top roast: '$bestRoast' \u{2014} Try AI Resume Roaster!";
  }

  void reset() {
    _result = null;
    _selectedFilePath = null;
    _selectedFileName = null;
    _selectedFileSize = null;
    _errorMessage = null;
    _isLoading = false;
    _savedRoasts = [];
    notifyListeners();
  }
}
