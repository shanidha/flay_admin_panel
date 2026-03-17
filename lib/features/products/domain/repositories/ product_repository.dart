import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<void> addProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
  Future<void> deleteProduct(String productId);
  Stream<List<ProductEntity>> getProducts();
}