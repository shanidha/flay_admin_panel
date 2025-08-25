import 'package:equatable/equatable.dart';

class AddBrandState extends Equatable {
  final bool loading;
  final bool success;
  final String? error;
  const AddBrandState({this.loading = false, this.success = false, this.error});

  AddBrandState copyWith({bool? loading, bool? success, String? error}) =>
      AddBrandState(loading: loading ?? this.loading, success: success ?? this.success, error: error);

  @override
  List<Object?> get props => [loading, success, error];
}