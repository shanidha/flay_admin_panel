import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/brand_entity.dart';
import '../../domain/usecases/create_brand.dart';
import 'brand_event.dart';
import 'brand_state.dart';

class AddBrandBloc extends Bloc<AddBrandEvent, AddBrandState> {
  final CreateBrandUseCase createBrand;

  AddBrandBloc(this.createBrand) : super(const AddBrandState()) {
    on<AddBrandSubmitted>(_onSubmit);
    on<AddBrandReset>((e, emit) => emit(const AddBrandState()));
  }

  Future<void> _onSubmit(
    AddBrandSubmitted e,
    Emitter<AddBrandState> emit,
  ) async {
    emit(state.copyWith(loading: true, success: false, error: null));
    try {
      final brand = Brand(
        id: '', // Firestore can auto-generate; keep empty
        name: e.name,
        logoUrl: e.logoUrl,
        categoryIds: e.categoryIds,
        createdAt: DateTime.now(),
      );
      await createBrand(brand);
      emit(state.copyWith(loading: false, success: true));
    } catch (err) {
      emit(state.copyWith(loading: false, error: err.toString()));
    }
  }
}