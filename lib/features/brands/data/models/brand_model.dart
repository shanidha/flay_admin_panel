import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/brand_entity.dart';

class BrandModel extends Brand {
  const BrandModel({
    required super.id,
    required super.name,
    super.logoUrl,
    required super.categoryIds,
    required super.createdAt,
  });

  factory BrandModel.fromDoc(DocumentSnapshot doc) {
    final m = doc.data() as Map<String, dynamic>;
    return BrandModel(
      id: doc.id,
      name: (m['name'] ?? '') as String,
      logoUrl: m['logoUrl'] as String?,
      categoryIds: (m['categoryIds'] as List?)?.cast<String>() ?? const [],
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'logoUrl': logoUrl,
    'categoryIds': categoryIds,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}