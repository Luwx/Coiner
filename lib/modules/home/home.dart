import 'package:coiner_app/core/erros/erros.dart';
import 'package:coiner_app/modules/home/home_controller.dart';
import 'package:coiner_app/modules/home/widgets/coin_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/coin.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coiner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<HomeController>().loadData();
            },
          ),
        ],
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          final state = controller.state;
          return state.when(
            onLoadingData: () => const Center(
              child: CircularProgressIndicator(),
            ),
            onLoadedData: (list) => _buildCoinList(list, context, controller),
            onLoadingError: (falha) =>
                _buildErrorWidget(falha, context, controller),
          );
        },
      ),
    );
  }

  Widget _buildCoinList(
    List<Coin> list,
    BuildContext context,
    HomeController controller,
  ) {
    final coinList = controller.showFavoriteOnly
        ? list.where((coin) => coin.isFavorite).toList()
        : list;
    return Column(
      children: [
        SwitchListTile(
          //tileColor: Colors.red,
          title: const Text('Mostrar somente favoritos'),
          value: controller.showFavoriteOnly,
          onChanged: (val) => controller.toggleShowFavoriteOnly(val),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width < 800 ? 1 : 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: coinList.length,
            itemBuilder: (context, index) {
              final coin = coinList[index];
              return CoinCard(
                coin: coin,
                onFavoriteToggle: () async {
                  bool favoritado = !coin.isFavorite;
                  final result =
                      await controller.toggleFavorite(coin.id!).run();
                  final mensagem = result.match(
                    (falha) =>
                        "Falha ${falha.mensagem} ao ${favoritado ? 'desfavoritar' : 'favoritar'} a moeda ${coin.id}",
                    (_) =>
                        "Modeda ${coin.id} ${favoritado ? 'desfavoritada' : 'favoritada'}",
                  );
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(mensagem),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorWidget(
    Falha falha,
    BuildContext context,
    HomeController controller,
  ) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Falha ao carregar os dados',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                controller.loadData();
              },
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
