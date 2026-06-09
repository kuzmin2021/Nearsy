# Repository Guidelines

## Project Structure & Module Organization

This is a Flutter mobile/web app generated from FlutterFlow and customized with the local Floter framework. Main Dart code lives in `lib/`; entry points are `main.dart` and `index.dart`. Feature screens usually use paired files such as `profile_age_page_widget.dart` and `profile_age_page_model.dart`. Shared UI is in `lib/components/`, runtime helpers in `lib/floter/`, Supabase access in `lib/backend/`, and business logic in `lib/services/`. Tests live in `test/`. Assets are declared in `pubspec.yaml` and stored under `assets/images/`, `assets/i18n/`, and related folders. Database migrations are in `supabase/migrations/`.

## Build, Test, and Development Commands

- `flutter pub get`: install Dart and Flutter dependencies.
- `flutter run`: run the app on the selected device.
- `flutter run -d chrome`: run the web target locally.
- `flutter analyze`: run static analysis using `analysis_options.yaml`.
- `flutter test`: run widget and unit tests in `test/`.
- `flutter build apk` or `flutter build web`: create release artifacts for Android or web.
- `npx supabase start`: start the local Supabase stack, if backend testing is needed.
- `npx supabase db reset`: reapply migrations from `supabase/migrations/` to the local database.

Use `--dart-define` for runtime configuration, for example:

```bash
flutter run --dart-define=SUPABASE_URL=http://127.0.0.1:54321 --dart-define=SUPABASE_ANON_KEY=sb_publishable_xxx
```

## Coding Style & Naming Conventions

Follow Dart defaults from `package:flutter_lints/flutter.yaml`; this repo only overrides `unnecessary_string_escapes`. Use `dart format` or IDE formatting before committing. Keep two-space indentation, `lower_snake_case.dart` file names, `UpperCamelCase` classes, and `lowerCamelCase` members. Match the existing page pattern: each screen has a `Widget` file and matching `Model` file. Put reusable UI in `lib/components/` and business rules in `lib/services/`.

## Testing Guidelines

The project uses `flutter_test`. Name tests with `_test.dart` and keep them under `test/`, mirroring the source area where practical. Add widget smoke tests for new screens and unit tests for service-level validation or data transforms. Run `flutter analyze` and `flutter test` before opening a PR.

## Commit & Pull Request Guidelines

Recent history uses short, imperative commits such as `Add account email verification screen` and `Wire delete account confirmation`. Keep commits focused and user-visible. PRs should include a summary, test results, related issue or task links, and screenshots or screen recordings for UI changes. Call out Supabase migrations and required `--dart-define` values.

## Security & Configuration Tips

Do not commit real Supabase secrets. Use `.env.example` as a reference and pass values through `--dart-define`. Treat migration files as permanent history once shared.
