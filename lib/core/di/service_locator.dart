import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

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
import '../../features/categories/data/repositories/firestore_category_repository.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/categories/domain/usecases/add_category.dart';

final sl = GetIt.instance;
Future<void> initDependencies() async {
  // Firebase
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
 // Auth
  sl.registerLazySingleton<AuthRepository>(
    () => FirebaseAuthRepository(sl(), sl()),
  );
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => ForgotPassword(sl()));
  sl.registerLazySingleton(() => AuthStateStream(sl()));

  // Categories
  sl.registerLazySingleton<CategoryRepository>(
    () => FirestoreCategoryRepository(sl()),
  );

  sl.registerLazySingleton(() => AddCategory(sl()));
  //Brands
    sl.registerLazySingleton<BrandRepository>(() => BrandRepositoryImpl(sl()));
  sl.registerFactory(() => CreateBrandUseCase(sl()));
  sl.registerFactory<AddBrandBloc>(() => AddBrandBloc(sl()));

}