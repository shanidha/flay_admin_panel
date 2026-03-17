// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../domain/entities/category_entity.dart';
// import '../../domain/repositories/category_repository.dart';
// import '../models/category_model.dart';

import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addCategory(CategoryEntity category) async {
    await remoteDataSource.addCategory(Category.fromEntity(category));
  }

  @override
  Future<void> updateCategory(CategoryEntity category) async {
    await remoteDataSource.updateCategory(Category.fromEntity(category));
  }

  @override
  Future<void> deleteCategory(String categoryId) async {
    await remoteDataSource.deleteCategory(categoryId);
  }
}
// class FirestoreCategoryRepository implements CategoryRepository {
//   final FirebaseFirestore firestore;

//   FirestoreCategoryRepository(this.firestore);

//   @override
//   Future<void> addCategory(CategoryEntity category) async {
//     final model = Category.fromEntity(category);

//     await firestore.collection('categories').add(model.toMap());
//   }

//   @override
//   Future<void> updateCategory(CategoryEntity category) async {
//     final model = Category.fromEntity(category);

//     await firestore.collection('categories').doc(category.id).update(model.toMap());
//   }
// }