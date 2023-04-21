import 'package:flutter/material.dart';

import 'package:coiner_app/core/erros/erros.dart';
import 'package:coiner_app/data/models/coin.dart';
import 'package:coiner_app/data/repositories/coin_repository.dart';
import 'package:fpdart/fpdart.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._coinRepository) {
    loadData();
  }
  HomeState _state = LoadingData();
  HomeState get state => _state;

  bool _showFavoriteOnly = false;
  bool get showFavoriteOnly => _showFavoriteOnly;

  final CoinRepository _coinRepository;

  Future<void> loadData() async {
    _state = LoadingData();
    notifyListeners();

    final result = await _coinRepository.getCoins().run();

    result.match(
      (falha) => _state = LoadingError(falha: falha),
      (coinList) => _state = LoadedData(list: coinList),
    );

    notifyListeners();
  }

  TaskEither<Falha, Unit> toggleFavorite(String id) {
    return _coinRepository.toggleFavorite(id);
  }

  void toggleShowFavoriteOnly(bool value) {
    _showFavoriteOnly = !_showFavoriteOnly;
    notifyListeners();
  }
}


/// Classe abstrata que representa o estado da tela Home.
/// 
/// O metodo [when] recebe 3 funções que devem ser implementadas para cada estado
/// da tela Home.
abstract class HomeState {
  T when<T>({
    required T Function() onLoadingData,
    required T Function(List<Coin> list) onLoadedData,
    required T Function(Falha falha) onLoadingError,
  });
}

class LoadingData extends HomeState {
  @override
  T when<T>({
    required T Function() onLoadingData,
    required T Function(List<Coin> list) onLoadedData,
    required T Function(Falha falha) onLoadingError,
  }) {
    return onLoadingData();
  }
}

class LoadedData extends HomeState {
  final List<Coin> list;
  LoadedData({
    required this.list,
  });

  @override
  T when<T>({
    required T Function() onLoadingData,
    required T Function(List<Coin> list) onLoadedData,
    required T Function(Falha falha) onLoadingError,
  }) {
    return onLoadedData(list);
  }
}

class LoadingError extends HomeState {
  Falha falha;
  LoadingError({
    required this.falha,
  });

  @override
  T when<T>({
    required T Function() onLoadingData,
    required T Function(List<Coin> list) onLoadedData,
    required T Function(Falha falha) onLoadingError,
  }) {
    return onLoadingError(falha);
  }
}
