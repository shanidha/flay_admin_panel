class ProductEntity {
  final String id;
  final String title;
  final String createdBy;
  final String categoryId;
   final String categoryName;
 final String brandId;
  final String brandName;
  final String weight;
  final String gender;
  final List<String> sizes;
  final List<String> colors;
  final String description;
  final String tagNumber;
  final int stock;
  final double price;
  final double discount;
  final double tax;
  final String imageUrl;
  final String imagePath;
  final String imageMediaId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ProductEntity({
    required this.id,
    required this.title,
    required this.createdBy,
    required this.categoryId,
      required this.categoryName,
    required this.brandId,
    required this.brandName,
    required this.weight,
    required this.gender,
    required this.sizes,
    required this.colors,
    required this.description,
    required this.tagNumber,
    required this.stock,
    required this.price,
    required this.discount,
    required this.tax,
    required this.imageUrl,
    required this.imagePath,
    required this.imageMediaId,
    this.createdAt,
    this.updatedAt,
  });
}