import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class UpdateCategory {
  final CategoryRepository repo;

  UpdateCategory(this.repo);

  Future<void> call(CategoryEntity c) => repo.updateCategory(c);
}