/// Single source of truth for the languages the app ships with.
///
/// Adding a new language is intentionally cheap:
///   1. Add an `lib/l10n/app_<code>.arb` file (copy `app_en.arb` and translate).
///   2. Add one entry to this enum with the matching `code` and its `nativeName`.
///   3. Run `flutter gen-l10n`.
///
/// The UI (settings selector), the [supportedLocales] resolution and the
/// persisted locale code all derive from this enum, so no other code needs to
/// change to support an extra language.
enum AppLanguage {
  english('en', 'English'),
  chinese('zh', '中文'),
  japanese('ja', '日本語');

  const AppLanguage(this.code, this.nativeName);

  /// The ISO language code used both for the `Locale` and the persisted value.
  final String code;

  /// The language's name written in that language itself. Deliberately not
  /// localized so adding a language never requires per-locale translation keys.
  final String nativeName;

  /// The default language used when no preference is stored or the stored code
  /// is unknown (e.g. a backup from a build that supported more languages).
  static const AppLanguage fallback = AppLanguage.english;

  static AppLanguage fromCode(String? code) => AppLanguage.values.firstWhere(
        (language) => language.code == code,
        orElse: () => fallback,
      );
}
