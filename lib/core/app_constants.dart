/// Constants for internal notes and share sheets that are intentionally not localized.
///
/// User-facing copy must go through `AppLocalizations`; the strings here only
/// appear in internal notes or share sheets and are centralized so they are
/// easy to find and adjust.
const String kInitialBalanceNote = '初始余额';
const String kBackupShareText = 'ASM database backup';

/// Source label stored on FX snapshots that were auto-filled from the online
/// rate provider. Combined with the publish date when building the note.
const String kFxApiSourceLabel = 'frankfurter.app';
