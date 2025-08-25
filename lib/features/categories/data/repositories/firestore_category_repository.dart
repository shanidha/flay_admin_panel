import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/entities/category_entity.dart';

class FirestoreCategoryRepository implements CategoryRepository {
  final FirebaseFirestore _db;
  FirestoreCategoryRepository(this._db);

  @override
  Future<void> addCategory(CategoryEntity c) async {
    await _db.collection('categories').add({
      ...c.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}