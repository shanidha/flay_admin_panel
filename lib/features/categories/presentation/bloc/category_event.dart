

import 'package:equatable/equatable.dart';
import 'package:flay_admin_panel/features/categories/domain/entities/category_entity.dart';

abstract class AddCategoryEvent extends Equatable {
  const AddCategoryEvent();

  @override
  List<Object?> get props => [];
}
class AddCategorySubmitted extends AddCategoryEvent {
  final CategoryEntity category;

  const AddCategorySubmitted(this.category);

  @override
  List<Object?> get props => [category];
}
class EditCategorySubmitted extends EditCategoryEvent {
  final CategoryEntity category;

  const EditCategorySubmitted(this.category);

  @override
  List<Object?> get props => [category];
}

abstract class EditCategoryEvent extends Equatable {
  const EditCategoryEvent();

  @override
  List<Object?> get props => [];
}













// class AddCategorySubmitted extends AddCategoryEvent {
//   final String title;
//   final String createdBy;
//   final int stock;
//   final String imageUrl;
//   final String imagePath;
//   final String brand;
//   final String imageMediaId;
//   final String tagId;
//   final String description;

//   const AddCategorySubmitted({
//     required this.title,
//     required this.createdBy,
//     required this.stock,
//     required this.imageUrl,
//     required this.imagePath,
//     required this.brand,
//     required this.imageMediaId,
//     required this.tagId,
//     required this.description,
//   });

//   @override
//   List<Object?> get props => [
//         title,
//         createdBy,
//         stock,
//         imageUrl,
//         imagePath,
//         brand,
//         imageMediaId,
//         tagId,
//         description,
//       ];
// }




// class EditCategorySubmitted extends EditCategoryEvent {
//   final String id;
//   final String title;
//   final String createdBy;
//   final int stock;
//   final String tagId;
//   final String brand;
//   final String description;
//   final String imageUrl;
//   final String imagePath;
//   final String imageMediaId;

//   const EditCategorySubmitted(CategoryEntity category, {
//     required this.id,
//     required this.title,
//     required this.createdBy,
//     required this.stock,
//     required this.tagId,
//     required this.brand,
//     required this.description,
//     required this.imageUrl,
//     required this.imagePath,
//     required this.imageMediaId,
//   });

//   @override
//   List<Object?> get props => [
//         id,
//         title,
//         createdBy,
//         stock,
//         tagId,
//         brand,
//         description,
//         imageUrl,
//         imagePath,
//         imageMediaId,
//       ];
// }
// abstract class AddCategoryEvent extends Equatable { const AddCategoryEvent(); @override List<Object?> get props => []; }

// class AddCategorySubmitted extends AddCategoryEvent {
//   final String title;
//   final String createdBy;
//   final int stock; 
//    final String imageUrl;
//   final String imagePath;
//   final String brand;
//   final String imageMediaId;


//   final String tagId;
//   final String description;
//   const AddCategorySubmitted({required this.title, required this.createdBy, required this.imageUrl,
//     required this.imagePath,  required this.brand,
//     required this.imageMediaId, required this.stock, required this.tagId, required this.description});
// }