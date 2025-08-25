import 'package:equatable/equatable.dart';

class Brand extends Equatable {
  final String id;
  final String name;
  final String? logoUrl;
  final List<String> categoryIds;
  final DateTime createdAt;

  const Brand({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.categoryIds,
    required this.createdAt,
  });

  Brand copyWith({
    String? id,
    String? name,
    String? logoUrl,
    List<String>? categoryIds,
    bool? featured,
    bool? active,
    DateTime? createdAt,
  }) {
    return Brand(
      id: id ?? this.id,
      name: name ?? this.name,
      logoUrl: logoUrl ?? this.logoUrl,
      categoryIds: categoryIds ?? this.categoryIds,
      
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, name, logoUrl, categoryIds,  createdAt];
}