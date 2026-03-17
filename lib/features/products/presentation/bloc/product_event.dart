import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadProducts extends ProductEvent {
  const LoadProducts();
}

class ProductsUpdated extends ProductEvent {
  final List<ProductEntity> products;
  const ProductsUpdated(this.products);

  @override
  List<Object?> get props => [products];
}

class AddProductSubmitted extends ProductEvent {
  final ProductEntity product;
  const AddProductSubmitted(this.product);

  @override
  List<Object?> get props => [product];
}

class UpdateProductSubmitted extends ProductEvent {
  final ProductEntity product;
  const UpdateProductSubmitted(this.product);

  @override
  List<Object?> get props => [product];
}

class DeleteProductSubmitted extends ProductEvent {
  final String productId;
  const DeleteProductSubmitted(this.productId);

  @override
  List<Object?> get props => [productId];
}