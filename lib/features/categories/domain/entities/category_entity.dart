class CategoryEntity {
  final String title;
  final String createdBy;
  final int stock;
  final String tagId;
  final String description;
  CategoryEntity({
    required this.title,
    required this.createdBy,
    required this.stock,
    required this.tagId,
    required this.description,
  });

  Map<String, dynamic> toMap() => {
    'title': title,
    'createdBy': createdBy,
    'stock': stock,
    'tagId': tagId,
    'description': description,
  };
}