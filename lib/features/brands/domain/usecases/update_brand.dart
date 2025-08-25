import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class UpdateBrandUseCase {
  final BrandRepository repository;
  UpdateBrandUseCase(this.repository);

  Future<void> call(Brand brand) {
    return repository.updateBrand(brand);
  }
}