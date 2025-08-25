import 'package:equatable/equatable.dart';

abstract class AddBrandEvent extends Equatable {
  const AddBrandEvent();
  @override
  List<Object?> get props => [];
}

class AddBrandSubmitted extends AddBrandEvent {
  final String name;
  final List<String> categoryIds;
  final String? logoUrl;
  const AddBrandSubmitted({required this.name, this.categoryIds = const [], this.logoUrl});
  @override
  List<Object?> get props => [name, categoryIds, logoUrl];

}class AddBrandReset extends AddBrandEvent {
  const AddBrandReset();
}