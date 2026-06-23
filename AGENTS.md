# AGENTS.md

`asm` is a Flutter app (Drift/SQLite + Riverpod + go_router + fl_chart) — a
family net-worth snapshot tracker. See `README.md` for the product overview and
`.cursor/rules/architecture.mdc` for layering rules.

Standard developer commands are documented in `README.md` (`flutter pub get`,
`flutter analyze`, `flutter test`, `flutter run`, `dart run build_runner build`,
`flutter gen-l10n`). The CI pipeline is `.github/workflows/ci.yml`.

## Cursor Cloud specific instructions

- The Flutter SDK (stable, Dart 3.12.2) is installed at `~/flutter` and is added
  to `PATH` via `~/.bashrc` (`~/flutter/bin` and `~/.pub-cache/bin`). New
  interactive shells pick it up automatically. The startup update script only
  runs `flutter pub get`.
- There is **no backend/server**: this is a single self-contained client app
  with a local embedded database. No external service is required to exercise
  the core flows. S3 backup and OS local notifications are optional and not
  needed for net-worth tracking.
- The VM is headless Linux, so run the app as a **web** target:
  `flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0`. The web
  build ships its own SQLite via `web/sqlite3.wasm` + `web/drift_worker.js`.
  With the `web-server` device the app only finishes connecting once a browser
  loads the page; first load compiles for ~20-30s. `flutter run -d chrome` also
  works (Chrome is installed).
- Drift `*.g.dart` and the generated `lib/l10n/app_localizations*.dart` are
  committed, so `build_runner`/`gen-l10n` are not required just to run, test, or
  analyze. Only regenerate after editing `lib/data/db/tables.dart` or the
  `lib/l10n/*.arb` files.
- `flutter test` logs a non-fatal `Notifications unavailable:
  LateInitializationError` line — this is expected on headless/web (no native
  notification plugin) and does not fail the suite.
