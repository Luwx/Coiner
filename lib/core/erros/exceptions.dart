class LocalDatabaseException implements Exception {
  LocalDatabaseException(String msg) : message = "Erro local database: $msg";
  final String message;

  @override
  String toString() => message;
}

class RemoteDatabaseException implements Exception {
  RemoteDatabaseException(String msg) : message = "Erro remote database: $msg";
  final String message;

  @override
  String toString() => message;
}