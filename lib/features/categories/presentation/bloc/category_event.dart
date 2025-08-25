

import 'package:equatable/equatable.dart';

abstract class AddCategoryEvent extends Equatable { const AddCategoryEvent(); @override List<Object?> get props => []; }

class AddCategorySubmitted extends AddCategoryEvent {
  final String title;
  final String createdBy;
  final int stock;
  final String tagId;
  final String description;
  const AddCategorySubmitted({required this.title, required this.createdBy, required this.stock, required this.tagId, required this.description});
}