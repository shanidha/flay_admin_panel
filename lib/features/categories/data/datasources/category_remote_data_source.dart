import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<void> addCategory(Category category);
  Future<void> updateCategory(Category category);
    Future<void> deleteCategory(String categoryId);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;

  CategoryRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _categoriesCollection =>
      firestore.collection('categories');

  @override
  Future<void> addCategory(Category category) async {
    await _categoriesCollection.add(category.toMap());
  }

  @override
  Future<void> updateCategory(Category category) async {
    await _categoriesCollection.doc(category.id).update(category.toMap());
  }
    @override
  Future<void> deleteCategory(String categoryId) async {
    await _categoriesCollection.doc(categoryId).delete();
  }
}