

import 'package:flay_admin_panel/features/categories/domain/entities/category_entity.dart';



abstract class CategoryRepository {
  Future<void> addCategory(CategoryEntity category);
   Future<void> updateCategory(CategoryEntity category);
  Future<void> deleteCategory(String categoryId);
}