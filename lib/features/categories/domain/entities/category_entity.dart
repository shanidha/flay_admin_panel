class CategoryEntity {
  final String title;
    final String id;
  final String createdBy;
  final int stock;
  final String tagId;
   final String brand;
  final String description;
   final String imageUrl;
  final String imagePath;
  final String imageMediaId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  CategoryEntity({
    required this.title,
    required this.id,
    required this.brand,
    required this.createdBy,
    required this.stock,
    required this.tagId,
    required this.description,
     required this.imageUrl,
    required this.imagePath,
    required this.imageMediaId,
    this.createdAt,
    this.updatedAt,
  });

 Map<String, dynamic> toMap() => {
        'title': title,
        'createdBy': createdBy,
        'stock': stock,
        'tagId': tagId,
        'brand': brand,
        'description': description,
        'imageUrl': imageUrl,
        'imagePath': imagePath,
        'imageMediaId': imageMediaId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };
}