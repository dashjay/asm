Future<String> openDatabaseFile(String dir) =>
    throw UnsupportedError('Not supported on web');

Future<void> copyDatabaseFile(String source, String dest) =>
    throw UnsupportedError('Not supported on web');

Future<void> replaceDatabaseFile(String pickedPath, String dest) =>
    throw UnsupportedError('Not supported on web');

Future<void> deleteFileIfExists(String path) =>
    throw UnsupportedError('Not supported on web');

Future<bool> isValidSqliteBackupFile(String path) =>
    throw UnsupportedError('Not supported on web');

Future<String> writeBytesToTempFile(String dir, String name, List<int> bytes) =>
    throw UnsupportedError('Not supported on web');
