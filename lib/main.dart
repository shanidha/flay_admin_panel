import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flay_admin_panel/features/brands/presentation/bloc/brand_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/resources/app_colors.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_screen.dart';
import 'features/categories/domain/usecases/add_category.dart';
import 'features/categories/presentation/bloc/category_bloc.dart';
import 'features/shell/presentation/bloc/shell_bloc.dart';

Future<void> main() async {
  //Initialize flutter Widgets
  WidgetsFlutterBinding.ensureInitialized();
  //Connect Firebase to Admin Panel
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
      apiKey: "AIzaSyAbYVp6_qk7BTseDIAuZ0SGslAihR6aYbA",
      projectId: "flay-8faa5",
      messagingSenderId: "125664788596",
      appId: "1:125664788596:web:e1aefe9ea8a4dd4da89121",
    ));

    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      webExperimentalAutoDetectLongPolling: true,
    );
  } else {
    await Firebase.initializeApp();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }
  //Initialize dependencies

    await initDependencies();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(sl(), sl(), sl(), sl())),
        BlocProvider(create: (_) => ShellBloc()),
        BlocProvider(create: (_) => AddCategoryBloc(sl<AddCategory>())),
           BlocProvider(create: (_) => sl<AddBrandBloc>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flay Admin',
        theme: ThemeData(
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.appBackground,
          useMaterial3: false,
        ),
        home: const LoginScreenPage(),
      ),
    );
  }
}