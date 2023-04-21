import 'package:coiner_app/core/erros/exceptions.dart';

abstract class Falha {
  Falha(this.mensagem, {this.stackTrace});
  final String mensagem;
  final StackTrace? stackTrace;

  Falha adicionarMensagem(String mensagem);
}

class FalhaSemConexao extends Falha {
  FalhaSemConexao(super.mensagem, {super.stackTrace});

  @override
  Falha adicionarMensagem(String mensagem) =>
      FalhaSemConexao("$mensagem, ${this.mensagem}");

  @override
  String toString() =>
      'FalhaSemConexao(mensagem: $mensagem), stackTrace: $stackTrace';
}


class FalhaLocalDatabase extends Falha {
  FalhaLocalDatabase(super.mensagem, {super.stackTrace});

  @override
  Falha adicionarMensagem(String mensagem) =>
      FalhaLocalDatabase("$mensagem, ${this.mensagem}");

  @override
  String toString() =>
      'FalhaLocalDatabase(mensagem: $mensagem), stackTrace: $stackTrace';
}

class FalhaRemoteDatabase extends Falha {
  FalhaRemoteDatabase(super.mensagem, {super.stackTrace});

  @override
  Falha adicionarMensagem(String mensagem) =>
      FalhaRemoteDatabase("$mensagem, ${this.mensagem}");

  @override
  String toString() =>
      'FalhaRemoteDatabase(mensagem: $mensagem), stackTrace: $stackTrace';
}

Falha mapDatabaseFalha(Object e, StackTrace stackTrace) {
  if (e is RemoteDatabaseException) {
    return FalhaRemoteDatabase(e.toString(), stackTrace: stackTrace);
  } else if (e is LocalDatabaseException) {
    return FalhaLocalDatabase(e.toString(), stackTrace: stackTrace);
  } else {
    // Deixar o erro explodir se não for um erro de banco de dados,
    // a stacktrace será útil para debugar.
    throw e;
  }
}