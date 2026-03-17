import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/category_entity.dart';

class Category extends CategoryEntity {
   Category({
    required super.id,
    required super.title,
     required super.brand,
    required super.createdBy,
    required super.stock,
    required super.tagId,
    required super.description,
    required super.imageUrl,
    required super.imagePath,
    required super.imageMediaId,
    super.createdAt,
    super.updatedAt,
  });

  factory Category.fromEntity(CategoryEntity entity) {
    return Category(
      id: entity.id,
       brand: entity.brand,
      title: entity.title,
      createdBy: entity.createdBy,
      stock: entity.stock,
      tagId: entity.tagId,
      description: entity.description,
      imageUrl: entity.imageUrl,
      imagePath: entity.imagePath,
      imageMediaId: entity.imageMediaId,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'createdBy': createdBy,
      'stock': stock,
      'tagId': tagId,
       'brand': brand,
      'description': description,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'imageMediaId': imageMediaId,
      'createdAt': createdAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? FieldValue.serverTimestamp() : Timestamp.fromDate(updatedAt!),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map, String docId) {
    return Category(
    
      id: docId,
    title: (map['title'] ?? '').toString(),
     brand: (map['brand'] ?? '').toString(),
    createdBy: (map['createdBy'] ?? '').toString(),
    stock: map['stock'] is int
        ? map['stock'] as int
        : int.tryParse('${map['stock'] ?? 0}') ?? 0,
    tagId: (map['tagId'] ?? '').toString(),
    description: (map['description'] ?? '').toString(),
    imageUrl: (map['imageUrl'] ?? '').toString(),
    imagePath: (map['imagePath'] ?? '').toString(),
    imageMediaId: (map['imageMediaId'] ?? '').toString(),
    createdAt: map['createdAt'] is Timestamp
        ? (map['createdAt'] as Timestamp).toDate()
        : null,
    updatedAt: map['updatedAt'] is Timestamp
        ? (map['updatedAt'] as Timestamp).toDate()
        : null,
  );
  }
}