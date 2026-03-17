import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/ product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addProduct(ProductEntity product) async {
    await remoteDataSource.addProduct(Product.fromEntity(product));
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    await remoteDataSource.updateProduct(Product.fromEntity(product));
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await remoteDataSource.deleteProduct(productId);
  }

  @override
  Stream<List<ProductEntity>> getProducts() {
    return remoteDataSource.getProducts();
  }
}