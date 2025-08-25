
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecases/add_category.dart';
import 'category_event.dart';
import 'category_state.dart';

// part 'add_category_event.dart';
// part 'add_category_state.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final AddCategory _addCategory;
  AddCategoryBloc(this._addCategory) : super(const AddCategoryState.initial()) {
    on<AddCategorySubmitted>(_onSubmit);
  }

  Future<void> _onSubmit(AddCategorySubmitted e, Emitter<AddCategoryState> emit) async {
    emit(const AddCategoryState.loading());
    try {
      await _addCategory(CategoryEntity(
        title: e.title,
        createdBy: e.createdBy,
        stock: e.stock,
        tagId: e.tagId,
        description: e.description,
      ));
      emit(const AddCategoryState.success());
    } catch (err) {
      emit(AddCategoryState.failure(err.toString()));
    }
  }
}