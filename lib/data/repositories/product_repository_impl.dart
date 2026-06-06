import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_local_data_source.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  @override
  Future<List<Product>> getProducts() async {
    try {
      return await remoteDataSource.fetchProducts();
    } catch (_) {
      return localDataSource.fallbackProducts();
    }
  }
}
