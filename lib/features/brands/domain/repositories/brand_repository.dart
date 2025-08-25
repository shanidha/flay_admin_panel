
import '../entities/brand_entity.dart';

abstract class BrandRepository {
  Future<void> createBrand(Brand brand);
  Future<List<Brand>> getBrands();
  Future<void> deleteBrand(String id);
  Future<void> updateBrand(Brand brand);
}