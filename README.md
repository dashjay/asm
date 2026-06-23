# ASM — Family Asset Manager

> Read this in other languages: [简体中文](README_zh-CN.md)

A simple, offline-first **family net-worth tracker**. Spend five minutes each
period updating your account balances and instantly see how your family's wealth
is doing across people, accounts, and currencies.

Built with Flutter, Drift (SQLite), Riverpod, go_router, and fl_chart.

---

## What this is (and isn't)

ASM is a **net-worth snapshot tracker**, not a transaction ledger.

- It records *"the balance of each account at a point in time"*, **not** every
  individual transaction.
- The core value loop is: **periodically update balances → see family net worth
  and its trend → understand your financial picture at a glance.**
- Its edge is being **low-effort, family-oriented, and multi-currency** — not
  being exhaustive.

Deliberately **out of scope** (to stay simple):

- Daily transaction / double-entry bookkeeping
- Budgeting envelopes and bill management
- Automatic bank/credit-card aggregation
- Social features or financial-product marketing

The guiding principle for every feature decision is: *protect the "see your net
worth in 5 minutes" experience.* The product succeeds or fails on one thing —
**whether users keep coming back to update their balances** — so the metric that
matters most is the **balance-update adherence rate**, not raw DAU.

---

## Current features

- **Family & accounts** — multiple family members, each with multiple accounts.
- **Account categories** — current (cash), fixed asset, investment, liability,
  receivable. Liabilities subtract from net worth automatically.
- **Multi-currency** — CNY / USD / SGD with per-snapshot FX rates and a single
  configurable display currency.
- **Balance snapshots** — an update wizard captures FX rates and per-account
  balances together; the dashboard collapses same-day updates into one trend point.
- **Net-worth trend chart** — family total over time with a linear forecast,
  plus a detail view that can be **filtered by any combination of members and
  asset categories** (multi-select) so category shifts read correctly.
- **Home dashboard** — current net worth, change since last update, days since
  last update, and accounts that are overdue for an update.
- **Update reminders** — per-account reminder intervals with local notifications.
- **Change reasons** — tag each balance change (salary, investment return, loan
  repayment, asset purchase, transfer, gift, FX fluctuation, other).
- **Backup** — local export/import plus S3-compatible backup.
- **Localization** — English and Simplified Chinese.

---

## Roadmap

Prioritized from a product perspective. Everything is ordered by its impact on
the core loop (keeping users updating their balances) and on differentiation.

### P0 — Protect the core loop & build financial trust

1. **App lock (PIN + biometrics).** Table stakes for a finance app; today the
   full family balance sheet is visible with no lock screen.
2. **Automatic FX rate fetching (with manual override).** Manual entry of
   USD→CNY / USD→SGD every update is the biggest friction in the ritual. Fetch
   online, one-tap fill, still editable, and fall back to manual/defaults
   offline. Lowering update friction directly raises update adherence.
3. **Minimal-input updates.** Pre-fill last period's balances and only edit what
   changed; a "no change this time" shortcut; surface "accounts not yet updated"
   inside the update flow.
4. **Reliable auto-backup & confident restore.** Scheduled backups, a visible
   "last backed up" timestamp, and a pre-restore validation/preview.

### P1 — Deepen insight (retention & differentiation)

5. **Asset allocation view.** Breakdown by category / member / currency, plus how
   allocation drifts over time. Pairs naturally with the multi-select trend filter.
6. **Net-worth change attribution.** Aggregate the existing change reasons into
   *"net worth grew by X: you saved A, investments earned B, FX moved C."* The
   data model already supports this — it's the strongest differentiator.
7. **Goals & savings rate.** Target net worth / FIRE number with progress, and a
   monthly savings rate, giving users a reason to keep the habit.
8. **Period comparisons.** MoM / YoY / YTD for net worth and per-category change.

### P2 — Expand the boundaries (growth & breadth)

9. **Multi-device / family sync.** The high-value "family" scenario is each
   spouse updating their own accounts. Large effort (accounts, conflict merge,
   end-to-end encryption); a read-only shared report can bridge the gap first.
10. **Reports & export.** CSV / monthly PDF summaries.
11. **Richer asset modeling (optional).** Track investments as *shares × price*
    rather than a single total, behind an advanced toggle, to avoid drifting
    away from "simple".

### If we could only do three things

1. **App lock** — the trust floor.
2. **Automatic FX + minimal-input updates** — minimize update friction and keep
   the core loop alive.
3. **Net-worth change attribution** — turn data we already have into an insight
   competitors lack.

The first two ensure *users come back*; the third ensures *they can't leave*.

---

## Architecture

Layers depend downward only:

- `lib/features/**` — UI (pages/widgets). May depend on core + domain + l10n.
- `lib/core/**` — providers, router, theme, notifications, backup, constants.
- `lib/data/**` — Drift database (`db/`) and repositories (`repositories/`).
- `lib/domain/**` — pure Dart: calculators, currency, forecast, enums (no
  Flutter/Drift imports).
- `lib/l10n/**` — generated localizations.

Key conventions:

- UI never touches `AppDatabase` directly; it goes through a repository exposed
  via a Riverpod provider.
- Database-derived state is exposed as `StreamProvider`s driven by Drift
  `watch()` / `dashboardChanges()`, so totals never go stale.
- Domain code stays framework-free and unit-testable.

---

## Getting started

Prerequisites: a recent [Flutter](https://docs.flutter.dev/get-started/install)
stable SDK (Dart 3.12+).

```bash
flutter pub get          # install dependencies
flutter gen-l10n         # generate localizations
flutter run              # run on a connected device/emulator
```

Common development commands:

```bash
flutter analyze          # static analysis (must be clean)
flutter test             # run unit/widget tests
dart run build_runner build   # regenerate Drift code after editing tables
```

When adding user-facing copy, edit `lib/l10n/app_en.arb` and `lib/l10n/app_zh.arb`,
then run `flutter gen-l10n`. After changing Drift tables in
`lib/data/db/tables.dart`, bump `schemaVersion`, add an `onUpgrade` step, and
regenerate the Drift code.
