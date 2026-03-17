
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_category.dart';
import '../../domain/usecases/update_category.dart';
import 'category_event.dart';
import 'category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final AddCategory _addCategory;

  AddCategoryBloc(this._addCategory)
      : super(const AddCategoryState.initial()) {
    on<AddCategorySubmitted>(_onSubmit);
  }
Future<void> _onSubmit(
  AddCategorySubmitted e,
  Emitter<AddCategoryState> emit,
) async {
  emit(const AddCategoryState.loading());
  try {
    await _addCategory(e.category);
    emit(const AddCategoryState.success());
  } catch (err) {
    emit(AddCategoryState.failure(err.toString()));
  }
}
 }


class EditCategoryBloc extends Bloc<EditCategoryEvent, EditCategoryState> {
  final UpdateCategory _updateCategory;

  EditCategoryBloc(this._updateCategory)
      : super(const EditCategoryState.initial()) {
    on<EditCategorySubmitted>(_onSubmit);
  }
Future<void> _onSubmit(
  EditCategorySubmitted e,
  Emitter<EditCategoryState> emit,
) async {
  emit(const EditCategoryState.loading());
  try {
    await _updateCategory(e.category);
    emit(const EditCategoryState.success());
  } catch (err) {
    emit(EditCategoryState.failure(err.toString()));
  }
}












// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../domain/entities/category_entity.dart';
// import '../../domain/usecases/add_category.dart';
// import 'category_event.dart';
// import 'category_state.dart';

// // part 'add_category_event.dart';
// // part 'add_category_state.dart';
//   Future<void> _onSubmit(
//     AddCategorySubmitted e,
//     Emitter<AddCategoryState> emit,
//   ) async {
//     emit(const AddCategoryState.loading());

//     try {
//       await _addCategory(
//         CategoryEntity(
//           id: '',
//           title: e.title,
//           createdBy: e.createdBy,
//           stock: e.stock,
//           tagId: e.tagId,
//           brand: e.brand,
//           description: e.description,
//           imageUrl: e.imageUrl,
//           imagePath: e.imagePath,
//           imageMediaId: e.imageMediaId,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
//         ),
//       );

//       emit(const AddCategoryState.success());
//     } catch (err) {
//       emit(AddCategoryState.failure(err.toString()));
//     }
//   }

  // Future<void> _onSubmit(
  //   EditCategorySubmitted e,
  //   Emitter<EditCategoryState> emit,
  // ) async {
  //   emit(const EditCategoryState.loading());

  //   try {
  //     await _updateCategory(
  //       CategoryEntity(
  //         id: e.id,
  //         title: e.title,
  //         createdBy: e.createdBy,
  //         stock: e.stock,
  //         tagId: e.tagId,
  //         brand: e.brand,
  //         description: e.description,
  //         imageUrl: e.imageUrl,
  //         imagePath: e.imagePath,
  //         imageMediaId: e.imageMediaId,
  //         createdAt: null,
  //         updatedAt: DateTime.now(),
  //       ),
  //     );

  //     emit(const EditCategoryState.success());
  //   } catch (err) {
  //     emit(EditCategoryState.failure(err.toString()));
  //   }
  // }
}
// class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
//   final AddCategory _addCategory;
//   AddCategoryBloc(this._addCategory) : super(const AddCategoryState.initial()) {
//     on<AddCategorySubmitted>(_onSubmit);
//   }

//   Future<void> _onSubmit(AddCategorySubmitted e, Emitter<AddCategoryState> emit) async {
//     emit(const AddCategoryState.loading());
//     try {
//       await _addCategory(CategoryEntity(
//           id: '',
//         title: e.title,
//         createdBy: e.createdBy,
//         stock: e.stock,
//         tagId: e.tagId,
//         brand:e.brand,
//         description: e.description,
//           imageUrl: e.imageUrl,
//           imagePath: e.imagePath,
//           imageMediaId: e.imageMediaId,
//           createdAt: DateTime.now(),
//           updatedAt: DateTime.now(),
        
//       ));
//       emit(const AddCategoryState.success());
//     } catch (err) {
//       emit(AddCategoryState.failure(err.toString()));
//     }
//   }
// }