// Interfaces usadas para aplicar o princípio da inversão de dependência, a fim de remover
// a dependência direta das databases (hive, etc) dos repositorios e resto do app, facilitando
// a substituição de uma database por outra.

import 'package:coiner_app/data/models/coin.dart';

/// Interface para a busca de Coins
abstract class CoinRemoteDataSource {
  Future<List<Coin>> getCoins();
  Stream<List<Coin>> getCoinsStream();
}

/// Interface para a busca e insercao de moedas favoritadas no banco de dados local
abstract class FavoriteCoinsLocalDatabase {
  Future<List<String>> getFavoriteCoinsId();
  Future<void> toggleFavoriteCoin(String coindId);
}
