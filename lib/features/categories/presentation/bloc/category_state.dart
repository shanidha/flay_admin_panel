

import 'package:equatable/equatable.dart';

class AddCategoryState extends Equatable {
  final bool loading;
  final bool success;
  final String? error;
  const AddCategoryState({this.loading = false, this.success = false, this.error});

  const AddCategoryState.initial() : this();
  const AddCategoryState.loading() : this(loading: true);
  const AddCategoryState.success() : this(success: true);
  const AddCategoryState.failure(String e) : this(error: e);

  @override
  List<Object?> get props => [loading, success, error];
}


class EditCategoryState extends Equatable {
  final bool loading;
  final bool success;
  final String? error;

  const EditCategoryState({
    required this.loading,
    required this.success,
    required this.error,
  });

  const EditCategoryState.initial()
      : loading = false,
        success = false,
        error = null;

  const EditCategoryState.loading()
      : loading = true,
        success = false,
        error = null;

  const EditCategoryState.success()
      : loading = false,
        success = true,
        error = null;

  const EditCategoryState.failure(String this.error)
      : loading = false,
        success = false;

  @override
  List<Object?> get props => [loading, success, error];
}