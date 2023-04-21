import 'package:coiner_app/core/erros/erros.dart';
import 'package:fpdart/fpdart.dart';
import 'package:coiner_app/data/models/coin.dart';
import 'package:coiner_app/data/databases/shared_database_interfaces.dart';

/// Utiliza a interface [CoinRemoteDataSource] para obter dados da API CoinCap
/// e a interface [FavoriteCoinsLocalDatabase] para obter dados do banco de dados
/// local sobre as moedas favoritadas.
class CoinRepository {
  CoinRepository(this._coinRemoteDataSource, this._favoriteCoinsLocalDatabase);

  final CoinRemoteDataSource _coinRemoteDataSource;
  final FavoriteCoinsLocalDatabase _favoriteCoinsLocalDatabase;

  TaskEither<Falha, List<Coin>> getCoins() {
    return TaskEither.tryCatch(
      () async {
        final coins = await _coinRemoteDataSource.getCoins();
        final favorites =
            await _favoriteCoinsLocalDatabase.getFavoriteCoinsId();

        for (final coin in coins) {
          coin.isFavorite = favorites.contains(coin.id);
        }
        return coins;
      },
      mapDatabaseFalha,
    );
  }

  TaskEither<Falha, Unit> toggleFavorite(String coinId) {
    return TaskEither.tryCatch(
      () async {
        await _favoriteCoinsLocalDatabase.toggleFavoriteCoin(coinId);
        return unit;
      },
      mapDatabaseFalha,
    );
  }
}
