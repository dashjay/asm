/// Fallback FX rates used before the user records their first rate snapshot.
///
/// These are intentionally rough "good enough" defaults; once a real
/// [FxSnapshot] exists the stored rates always take precedence. Keeping them in
/// one place avoids the magic numbers that previously drifted across the
/// converter, repositories and the snapshot wizard.
const double kDefaultUsdToCny = 7.25;
const double kDefaultUsdToSgd = 1.35;
