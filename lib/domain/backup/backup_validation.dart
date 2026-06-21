/// Returns true when [bytes] begin with a SQLite 3 database header.
bool isSqliteDatabaseHeader(List<int> bytes) {
  if (bytes.length < 16) return false;
  const magic = 'SQLite format 3\u0000';
  return String.fromCharCodes(bytes.take(16)) == magic;
}
