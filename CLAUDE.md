# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AI Resume Roaster is a Flutter mobile app that uses the mlvoca.com API (tinyllama) to humorously critique resumes while providing genuine feedback. Users upload a PDF resume, choose a roast intensity level, and receive scored results with roast one-liners, category breakdowns, and constructive suggestions.

## Build & Run Commands

```bash
flutter pub get              # Install dependencies
flutter analyze              # Static analysis (must pass with no issues)
flutter test                 # Run all tests (32 tests across 6 files)
flutter test test/roast_result_test.dart   # Run a single test file
flutter run                  # Run on connected device/emulator
```

## Architecture

**State Management:** `InheritedNotifier` pattern via `RoastProviderScope` (defined in `main.dart`). Access provider with:
- `RoastProviderScope.of(context)` — registers dependency (rebuilds on change)
- `RoastProviderScope.read(context)` — one-shot read (no rebuild)

**Navigation flow:** SplashScreen → HomeScreen → UploadScreen → RoastingScreen → ResultsScreen

**Key architectural layers:**
- `lib/core/` — Constants (colors, strings, Gemini prompts), theme, utilities (PDF extraction, text cleaning)
- `lib/data/models/` — `RoastResult` (with `RoastLine`, `CategoryScore`, `ConstructiveFeedback`) — all have `fromJson`/`toJson`
- `lib/data/services/` — `GeminiService` calls mlvoca.com `/api/generate` with `tinyllama`, requests JSON response
- `lib/presentation/` — Screens, widgets, and provider

**mlvoca API integration:** `GeminiService.roastResume()` POSTs to `https://mlvoca.com/api/generate` with `model: "tinyllama"`, `prompt`, and `stream: false`. Response JSON’s `response` field is parsed as roast result. On parse failure, it retries once. The prompt template is in `core/constants/gemini_prompts.dart`.

**PDF pipeline:** `PdfExtractor` (syncfusion_flutter_pdf) → `TextCleaner` (whitespace/control char removal, 4000 char truncation) → mlvoca API

## Environment Setup

Optional `.env` at project root (in `.gitignore`), loaded via `flutter_dotenv` in `main.dart`. No API key is required for the mlvoca.com backend.

## Testing

- Unit tests: `roast_result_test.dart`, `text_cleaner_test.dart`, `pdf_extractor_test.dart`
- Widget tests: `home_screen_test.dart`, `upload_screen_test.dart`, `results_screen_test.dart`
- Widget tests use `tester.pump(Duration)` instead of `pumpAndSettle()` because screens have looping `flutter_animate` animations

## Theme

Dark fire theme defined in `core/theme/app_theme.dart`. Primary: `#FF4500`, Background: `#0A0A0A`. Fonts: Bebas Neue (headings), Inter (body) via `google_fonts`.
