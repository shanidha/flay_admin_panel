import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class CreateBrandUseCase {
  final BrandRepository repository;
  CreateBrandUseCase(this.repository);

  Future<void> call(Brand brand) {
    return repository.createBrand(brand);
  }
}