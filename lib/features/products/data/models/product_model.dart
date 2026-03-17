import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/product_entity.dart';

class Product extends ProductEntity {
  Product({
    required super.id,
    required super.title,
     required super.categoryName,
    required super.createdBy,
    required super.categoryId,
    required super.brandName,
      required super.brandId,
    required super.weight,
    required super.gender,
    required super.sizes,
    required super.colors,
    required super.description,
    required super.tagNumber,
    required super.stock,
    required super.price,
    required super.discount,
    required super.tax,
    required super.imageUrl,
    required super.imagePath,
    required super.imageMediaId,
    super.createdAt,
    super.updatedAt,
  });

  factory Product.fromEntity(ProductEntity entity) {
    return Product(
      id: entity.id,
       categoryName: entity.categoryName,
      title: entity.title,
      createdBy: entity.createdBy,
      categoryId: entity.categoryId,
      brandName: entity.brandName,
         brandId: entity.brandId,
      weight: entity.weight,
      gender: entity.gender,
      sizes: entity.sizes,
      colors: entity.colors,
      description: entity.description,
      tagNumber: entity.tagNumber,
      stock: entity.stock,
      price: entity.price,
      discount: entity.discount,
      tax: entity.tax,
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
      'categoryId': categoryId,
      'categoryName': categoryName,
      'brandName': brandName,
        'brandId': brandId,
      'weight': weight,
      'gender': gender,
      'sizes': sizes,
      'colors': colors,
      'description': description,
      'tagNumber': tagNumber,
      'stock': stock,
      'price': price,
      'discount': discount,
      'tax': tax,
      'imageUrl': imageUrl,
      'imagePath': imagePath,
      'imageMediaId': imageMediaId,
      'createdAt': createdAt == null ? null : Timestamp.fromDate(createdAt!),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String docId) {
    return Product(
      id: docId,
      title: map['title'] ?? '',
      createdBy: map['createdBy'] ?? '',
      categoryId: map['categoryId'] ?? '',
categoryName: map['categoryName'] ?? '',
      brandName: map['brandName'] ?? '',
          brandId: map['brandId'] ?? '',
      weight: map['weight'] ?? '',
      gender: map['gender'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? const []),
      colors: List<String>.from(map['colors'] ?? const []),
      description: map['description'] ?? '',
      tagNumber: map['tagNumber'] ?? '',
      stock: (map['stock'] ?? 0) is int
          ? map['stock'] ?? 0
          : int.tryParse(map['stock'].toString()) ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      discount: (map['discount'] ?? 0).toDouble(),
      tax: (map['tax'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      imagePath: map['imagePath'] ?? '',
      imageMediaId: map['imageMediaId'] ?? '',
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : null,
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }
}
// class Product {
//   final String image, title, sizeInfo, price, category;
//   final int stockLeft, soldCount;
//   final double rating;
//   final int reviewCount;

//   Product({
//     required this.image,
//     required this.title,
//     required this.sizeInfo,
//     required this.price,
//     required this.category,
//     required this.stockLeft,
//     required this.soldCount,
//     required this.rating,
//     required this.reviewCount,
//   });
// }
