import 'dart:convert';
import 'package:coiner_app/core/erros/exceptions.dart';
import 'package:coiner_app/data/databases/shared_database_interfaces.dart';
import 'package:http/http.dart' as http;
import 'package:coiner_app/data/models/coin.dart';

/// Implementa a interface [CoinRemoteDataSource] para obter dados da API CoinCap
class CoinCapHttpDataSourceImpl implements CoinRemoteDataSource {
  final String _baseUrl = 'https://api.coincap.io/v2';

  @override
  Future<List<Coin>> getCoins() async {
    final response = await http.get(Uri.parse('$_baseUrl/assets'));

    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List<dynamic> coinDataList = jsonResponse['data'];

        return coinDataList.map((coinData) => Coin.fromJson(coinData)).toList();
      } else {
        throw RemoteDatabaseException(
            'Falha ao carregar moedas: ${response.statusCode}');
      }
    } catch (e) {
      throw RemoteDatabaseException('Falha ao carregar moedas: $e');
    }
  }

  @override
  Stream<List<Coin>> getCoinsStream() {
    // TODO: implement getCoinsStream
    throw UnimplementedError();
  }
}
