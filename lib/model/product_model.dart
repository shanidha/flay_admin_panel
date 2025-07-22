class Product {
  final String image, title, sizeInfo, price, category;
  final int stockLeft, soldCount;
  final double rating;
  final int reviewCount;

  Product({
    required this.image,
    required this.title,
    required this.sizeInfo,
    required this.price,
    required this.category,
    required this.stockLeft,
    required this.soldCount,
    required this.rating,
    required this.reviewCount,
  });
}
