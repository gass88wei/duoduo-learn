# AGENTS.md — 多多学 Duoduo Learn

## Quick start
- `flutter pub get` — install deps
- `flutter run` — debug mode (any connected device)
- `flutter build apk --release` — release APK
- `flutter test` — run all tests (single smoke test in `test/widget_test.dart`)
- `flutter analyze` — static analysis (uses `flutter_lints` with defaults, no custom lint rules)

## Architecture
- **State**: Riverpod (`flutter_riverpod`) — all providers in `lib/core/providers/providers.dart`
- **DB**: SQLite (`sqflite`) — singleton `DatabaseHelper` at `lib/data/database/database_helper.dart`, DB version 1, file `dlg_q.db`
- **Entry**: `lib/main.dart` → `DIYDuolingoApp` wrapper → `MainApp` bottom nav (3 tabs: 学习/题库/我的)
- **Feature layout**: `lib/features/{home,deck,learning,ingestion,profile,settings}/` — each feature folder contains its own screen(s)
- **Services layer**: `lib/services/` — `gamification_service.dart`, `openai_service.dart`, `content_analyzer.dart`
- **Models**: `lib/data/models/` — `Deck`, `Question`, `StudyRecord`, `UserStats`, `QuestionType` enum
- **Sharing**: `receive_sharing_intent` handles text/image share-to-app (routes to `IngestionScreen`)
- **Assets**: `assets/images/`, `assets/icons/` — declared in `pubspec.yaml`

## Non-obvious conventions
- Package name is `dlg_q` (not `duoduo` or `dlg_q`)
- Error handling: global `runZonedGuarded` + custom `ErrorWidget.builder` on `DIYDuolingoApp` — both in `lib/main.dart`
- Learning mode + random level progress are persisted via `SharedPreferences` (not SQLite)
- DB schema: 4 tables (`decks`, `questions`, `study_records`, `user_stats`), user_stats is a single-row table (id=1)
- `DatabaseHelper` uses `ConflictAlgorithm.replace` for `upsertStudyRecord`
- `DeckOperations.saveAnalysisResult` auto-generates `deckId` from microseconds timestamp

## Gotchas
- No `.g.dart` / `.freezed.dart` codegen — models are hand-written with `toMap()`/`fromMap()` (gitignored anyway)
- No `.env` file for AI config — AI API endpoint/key/model are configured in-app (settings screen), not in env vars
- No CI pipeline configured — no `.github/` workflows
- No `openforge.json` or `CLAUDE.md` — only `AGENTS.md` and `README.md`
- `receive_sharing_intent` init errors are silently caught (release-mode safe)
- Java 17+ JDK required for Android builds (`JAVA_HOME` must point to JDK 17)
