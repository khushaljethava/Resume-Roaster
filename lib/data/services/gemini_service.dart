import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import '../../core/constants/gemini_prompts.dart';
import '../models/roast_result.dart';

const _apiUrl = 'https://mlvoca.com/api/generate';

const _models = ['tinyllama', 'deepseek-r1:1.5b'];

/// Retry on 502/503/504 (gateway timeout / server busy).
const _maxAttempts = 3;
const _retryDelay = Duration(seconds: 5);

class _ServiceException implements Exception {
  final int statusCode;
  final String message;
  _ServiceException(this.statusCode, this.message);
  @override
  String toString() => message;
}

class GeminiService {
  final Random _random = Random();

  String _pickModel() => _models[_random.nextInt(_models.length)];

  static String _sanitizeForUtf8(String s) {
    return String.fromCharCodes(
      s.runes.where((r) => r < 0xD800 || r > 0xDFFF),
    );
  }

  static bool _isRetryableStatus(int code) =>
      code == 502 || code == 503 || code == 504;

  Future<RoastResult> roastResume(
    String resumeText,
    String intensity, {
    bool useStreaming = false,
  }) async {
    final safeResume = _sanitizeForUtf8(resumeText);
    final prompt = GeminiPrompts.buildUserPrompt(safeResume, intensity);
    final model = _pickModel();

    final bodyMap = {
      'model': model,
      'prompt': _sanitizeForUtf8(prompt),
      'system': _sanitizeForUtf8(GeminiPrompts.systemInstruction),
      'stream': useStreaming,
      'format': 'json',
    };
    final bodyBytes = utf8.encode(jsonEncode(bodyMap));

    Exception? lastError;
    for (var attempt = 1; attempt <= _maxAttempts; attempt++) {
      final client = HttpClient();
      try {
        final fullText = await _doRequest(
          client: client,
          bodyBytes: bodyBytes,
          useStreaming: useStreaming,
        );
        return _parseResponse(fullText);
      } on _ServiceException catch (e) {
        lastError = e;
        if (!_isRetryableStatus(e.statusCode) || attempt == _maxAttempts) {
          break;
        }
        await Future.delayed(_retryDelay);
      } on SocketException catch (_) {
        lastError = Exception(
            'Cannot reach the roast service. Check your internet connection.');
        if (attempt == _maxAttempts) break;
        await Future.delayed(_retryDelay);
      } on ArgumentError catch (_) {
        throw Exception(
            'Invalid text in resume (encoding error). Try a different PDF.');
      } on FormatException catch (e) {
        lastError = e;
        if (attempt < _maxAttempts) {
          await Future.delayed(_retryDelay);
        } else {
          break;
        }
      } catch (e) {
        rethrow;
      } finally {
        client.close();
      }
    }
    throw lastError ?? Exception('Roast service error. Try again later.');
  }

  Future<String> _doRequest({
    required HttpClient client,
    required List<int> bodyBytes,
    required bool useStreaming,
  }) async {
    final request = await client.postUrl(Uri.parse(_apiUrl));
    request.headers.set('Content-Type', 'application/json; charset=utf-8');
    request.contentLength = bodyBytes.length;
    request.add(bodyBytes);

    final response = await request.close();

    if (response.statusCode != 200) {
      await response.drain();
      throw _ServiceException(
        response.statusCode,
        _messageForStatus(response.statusCode),
      );
    }

    if (useStreaming) {
      return await _readStreamingResponse(response);
    }
    final responseBody = await response.transform(utf8.decoder).join();
    final json = jsonDecode(responseBody) as Map<String, dynamic>;
    final text = json['response'] as String?;
    if (text == null || text.isEmpty) {
      throw Exception('Empty response from roast service.');
    }
    return text;
  }

  static String _messageForStatus(int code) {
    if (code == 504) {
      return 'Roast service is busy or slow (timeout). Try again in a moment.';
    }
    if (code == 502 || code == 503) {
      return 'Roast service is temporarily unavailable. Try again in a moment.';
    }
    return 'Roast service error $code. Try again later.';
  }

  /// Reads NDJSON streaming response per [MLvoca Free LLM API](https://mlvoca.github.io/free-llm-api/):
  /// newline-delimited JSON objects with "response" (chunk) and "done" (bool).
  /// Concatenates chunks until a line with "done": true.
  Future<String> _readStreamingResponse(HttpClientResponse response) async {
    final buffer = StringBuffer();
    var seenDone = false;
    await for (final chunk in response
        .transform(utf8.decoder)
        .transform(const LineSplitter())) {
      final line = chunk.trim();
      if (line.isEmpty) continue;
      try {
        final json = jsonDecode(line) as Map<String, dynamic>;
        final part = json['response'] as String?;
        if (part != null) buffer.write(part);
        if (identical(json['done'], true)) {
          seenDone = true;
          break;
        }
      } catch (_) {
        // Skip malformed lines (e.g. partial TCP chunk)
      }
    }
    final text = buffer.toString();
    if (!seenDone && text.isEmpty) {
      throw Exception('Stream ended without completion (no data).');
    }
    return text;
  }

  RoastResult _parseResponse(String text) {
    var cleaned = text.trim();
    if (cleaned.startsWith('```')) {
      cleaned = cleaned.replaceFirst(RegExp(r'^```\w*\n?'), '');
      cleaned = cleaned.replaceFirst(RegExp(r'\n?```$'), '');
    }

    try {
      final json = jsonDecode(cleaned) as Map<String, dynamic>;
      return RoastResult.fromJson(json);
    } catch (e) {
      throw FormatException('Failed to parse API response: $e');
    }
  }
}
