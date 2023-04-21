import 'package:coiner_app/data/databases/coin_cap_datasource/coin_cap_http_datasource.dart';
import 'package:coiner_app/data/databases/hive/hive_favorite_coins_database.dart';
import 'package:coiner_app/data/repositories/coin_repository.dart';
import 'package:coiner_app/modules/home/home.dart';
import 'package:coiner_app/modules/home/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>('favorite_movies');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Coiner App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => HomeController(
          CoinRepository(
            CoinCapHttpDataSourceImpl(),
            HiveFavoriteCoinsDatabaseImpl(
              Hive.box<String>('favorite_movies'),
            ),
          ),
        ),
        child: const HomePage(),
      ),
    );
  }
}
