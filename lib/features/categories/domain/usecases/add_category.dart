import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class AddCategory {
  final CategoryRepository repo;
  AddCategory(this.repo);
  Future<void> call(CategoryEntity c) => repo.addCategory(c);
}