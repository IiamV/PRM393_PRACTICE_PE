import 'package:flutter/material.dart';

import 'data/datasources/product_local_data_source.dart';
import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_products.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/state/app_scope.dart';
import 'presentation/state/app_state.dart';

void main() {
  final repository = ProductRepositoryImpl(
    remoteDataSource: ProductRemoteDataSource(),
    localDataSource: const ProductLocalDataSource(),
  );
  runApp(MyApp(repository: repository));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.repository});

  final ProductRepository repository;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppState _state;

  @override
  void initState() {
    super.initState();
    _state = AppState(getProducts: GetProducts(widget.repository));
    _state.loadProducts();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'E-Commerce UI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          fontFamily: 'Inter',
          scaffoldBackgroundColor: const Color(0xFF121022),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF2111D4),
            brightness: Brightness.dark,
            primary: const Color(0xFF2111D4),
            surface: const Color(0xFF19172B),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
