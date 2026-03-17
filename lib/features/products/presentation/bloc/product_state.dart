import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

class ProductState extends Equatable {
  final bool loading;
  final List<ProductEntity> products;
  final String? error;
  final bool success;

  const ProductState({
    this.loading = false,
    this.products = const [],
    this.error,
    this.success = false,
  });

  const ProductState.initial()
      : loading = false,
        products = const [],
        error = null,
        success = false;

  ProductState copyWith({
    bool? loading,
    List<ProductEntity>? products,
    String? error,
    bool? success,
  }) {
    return ProductState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      error: error,
      success: success ?? this.success,
    );
  }

  @override
  List<Object?> get props => [loading, products, error, success];
}