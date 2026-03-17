import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Stream<List<Product>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;

  ProductRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _products =>
      firestore.collection('products');

  @override
  Future<void> addProduct(Product product) async {
    await _products.add(product.toMap());
  }

  @override
  Future<void> updateProduct(Product product) async {
    await _products.doc(product.id).update(product.toMap());
  }

  @override
  Future<void> deleteProduct(String productId) async {
    await _products.doc(productId).delete();
  }

  @override
  Stream<List<Product>> getProducts() {
    return _products
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Product.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}