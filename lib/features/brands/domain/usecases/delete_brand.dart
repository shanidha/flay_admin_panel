
import '../repositories/brand_repository.dart';

class DeleteBrandUseCase {
  final BrandRepository repository;
  DeleteBrandUseCase(this.repository);

  Future<void> call(String id) {
    return repository.deleteBrand(id);
  }
}
