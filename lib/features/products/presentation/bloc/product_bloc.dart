import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_product.dart';
import '../../domain/usecases/delete_product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/update_product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final AddProduct addProduct;
  final UpdateProduct updateProduct;
  final DeleteProduct deleteProduct;
  final GetProducts getProducts;

  StreamSubscription? _subscription;

  ProductBloc({
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
    required this.getProducts,
  }) : super(const ProductState.initial()) {
    on<LoadProducts>(_onLoadProducts);
    on<ProductsUpdated>(_onProductsUpdated);
    on<AddProductSubmitted>(_onAddProduct);
    on<UpdateProductSubmitted>(_onUpdateProduct);
    on<DeleteProductSubmitted>(_onDeleteProduct);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) {
    emit(state.copyWith(loading: true, error: null));

    _subscription?.cancel();
    _subscription = getProducts().listen(
      (products) => add(ProductsUpdated(products)),
      onError: (e) => emit(state.copyWith(loading: false, error: e.toString())),
    );
  }

  void _onProductsUpdated(ProductsUpdated event, Emitter<ProductState> emit) {
    emit(state.copyWith(
      loading: false,
      products: event.products,
      error: null,
    ));
  }

  Future<void> _onAddProduct(
    AddProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null, success: false));
      await addProduct(event.product);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateProduct(
    UpdateProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null, success: false));
      await updateProduct(event.product);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  Future<void> _onDeleteProduct(
    DeleteProductSubmitted event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(state.copyWith(loading: true, error: null, success: false));
      await deleteProduct(event.productId);
      emit(state.copyWith(loading: false, success: true));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}