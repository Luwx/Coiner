import 'package:coiner_app/data/databases/shared_database_interfaces.dart';
import 'package:hive/hive.dart';

/// Implementa a interface [FavoriteCoinsLocalDatabase] para obter moedas favoritadas do 
/// banco de dados local
class HiveFavoriteCoinsDatabaseImpl implements FavoriteCoinsLocalDatabase {
  HiveFavoriteCoinsDatabaseImpl(this._box);

  final Box<String> _box;

  @override
  Future<List<String>> getFavoriteCoinsId() async {
    return _box.values.toList();
  }

  @override
  Future<void> toggleFavoriteCoin(String coindId) async {
    final values = _box.values.toList();
    if (values.contains(coindId)) {
      _box.delete(coindId);
    } else {
      _box.put(coindId, coindId);
    }
  }
}
