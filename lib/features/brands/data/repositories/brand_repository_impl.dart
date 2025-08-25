
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/repositories/brand_repository.dart';
import '../models/brand_model.dart';

class BrandRepositoryImpl implements BrandRepository {
  final FirebaseFirestore firestore;
  BrandRepositoryImpl(this.firestore);

  @override
  Future<void> createBrand(Brand brand) async {
    final model = BrandModel(
      id: brand.id,
      name: brand.name,
      logoUrl: brand.logoUrl,
      categoryIds: brand.categoryIds,
      createdAt: brand.createdAt,
    );
    await firestore.collection('brands').add(model.toMap());
  }

  @override
  Future<List<Brand>> getBrands() async {
    final snapshot = await firestore.collection('brands').get();
    return snapshot.docs.map((doc) => BrandModel.fromDoc(doc)).toList();
  }

  @override
  Future<void> deleteBrand(String id) async {
    await firestore.collection('brands').doc(id).delete();
  }

  @override
  Future<void> updateBrand(Brand brand) async {
    final model = BrandModel(
      id: brand.id,
      name: brand.name,
      logoUrl: brand.logoUrl,
      categoryIds: brand.categoryIds,
      createdAt: brand.createdAt,
    );
    await firestore.collection('brands').doc(brand.id).update(model.toMap());
  }
}