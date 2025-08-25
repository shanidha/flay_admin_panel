import '../entities/brand_entity.dart';
import '../repositories/brand_repository.dart';

class GetBrandsUseCase {
  final BrandRepository repository;
  GetBrandsUseCase(this.repository);

  Future<List<Brand>> call() {
    return repository.getBrands();
  }
}