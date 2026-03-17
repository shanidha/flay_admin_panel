import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import '../../features/auth/data/repositories/firebase_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/auth_state_stream.dart';
import '../../features/auth/domain/usecases/forgot_password.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/brands/data/repositories/brand_repository_impl.dart';
import '../../features/brands/domain/repositories/brand_repository.dart';
import '../../features/brands/domain/usecases/create_brand.dart';
import '../../features/brands/presentation/bloc/brand_bloc.dart';
import '../../features/categories/data/datasources/category_remote_data_source.dart';
import '../../features/categories/data/repositories/firestore_category_repository.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category.dart';
import '../../features/categories/domain/usecases/update_category.dart';
import '../../features/categories/presentation/bloc/category_bloc.dart';
import '../../features/media/data/datasources/media_remote_data_source.dart';
import '../../features/media/data/datasources/media_storage_data_source.dart';
import '../../features/media/data/repositories/media_repository_impl.dart';
import '../../features/media/domain/repositories/media_repository.dart';
import '../../features/media/domain/usecases/delete_media.dart';
import '../../features/media/domain/usecases/fetch_media_by_folder.dart';
import '../../features/media/domain/usecases/upload_media.dart';
import '../../features/media/presentation/bloc/media_bloc.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/ product_repository.dart';
import '../../features/products/domain/usecases/add_product.dart';
import '../../features/products/domain/usecases/delete_product.dart';
import '../../features/products/domain/usecases/get_products.dart';
import '../../features/products/domain/usecases/update_product.dart';
import '../../features/products/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;
Future<void> initDependencies() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);
   sl.registerLazySingleton(() => const Uuid());
 // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(sl(), sl()),
  );
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => AuthStateStream(sl()));

  // Categories
  // sl.registerLazySingleton<CategoryRepository>(
  //   () => FirestoreCategoryRepository(sl()),
  // );
  sl.registerLazySingleton(() => UpdateCategory(sl()));

sl.registerFactory(() => EditCategoryBloc(sl()));
sl.registerLazySingleton<CategoryRepository>(
  () => CategoryRepositoryImpl(remoteDataSource: sl()),
);

sl.registerLazySingleton<CategoryRemoteDataSource>(
  () => CategoryRemoteDataSourceImpl(firestore: sl()),
);
  sl.registerLazySingleton(() => AddCategory(sl()));
   sl.registerFactory<AddCategoryBloc>(() => AddCategoryBloc(sl<AddCategory>()));
  //Brands
    sl.registerLazySingleton<BrandRepository>(() => BrandRepositoryImpl(sl()));
  sl.registerFactory(() => CreateBrandUseCase(sl()));
  sl.registerFactory<AddBrandBloc>(() => AddBrandBloc(sl()));
 // Media data sources
  sl.registerLazySingleton<MediaRemoteDataSource>(
    () => MediaRemoteDataSourceImpl(firestore: sl<FirebaseFirestore>()),
  );
  sl.registerLazySingleton<MediaStorageDataSource>(
    () => MediaStorageDataSourceImpl(
      storage: sl<FirebaseStorage>(),
      uuid: sl<Uuid>(),
    ),
  );

  // Media repository
  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(
      remoteDataSource: sl<MediaRemoteDataSource>(),
      storageDataSource: sl<MediaStorageDataSource>(),
    ),
  );

  // Media use cases
  sl.registerLazySingleton(() => FetchMediaByFolder(sl<MediaRepository>()));
  sl.registerLazySingleton(() => UploadMedia(sl<MediaRepository>()));
  sl.registerLazySingleton(() => DeleteMedia(sl<MediaRepository>()));

  // Media bloc
  sl.registerFactory<MediaBloc>(
    () => MediaBloc(
      fetchMediaByFolder: sl<FetchMediaByFolder>(),
      uploadMedia: sl<UploadMedia>(),
      deleteMedia: sl<DeleteMedia>(),
    ),
  );
  //Products
  sl.registerLazySingleton<ProductRemoteDataSource>(
  () => ProductRemoteDataSourceImpl(firestore: sl()),
);

sl.registerLazySingleton<ProductRepository>(
  () => ProductRepositoryImpl(remoteDataSource: sl()),
);

sl.registerLazySingleton(() => AddProduct(sl()));
sl.registerLazySingleton(() => UpdateProduct(sl()));
sl.registerLazySingleton(() => DeleteProduct(sl()));
sl.registerLazySingleton(() => GetProducts(sl()));

sl.registerFactory(
  () => ProductBloc(
    addProduct: sl(),
    updateProduct: sl(),
    deleteProduct: sl(),
    getProducts: sl(),
  ),
);
}