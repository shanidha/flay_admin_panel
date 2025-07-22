import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flay_admin_panel/controller/dashboard_controller.dart';
import 'package:flay_admin_panel/view/auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/auth_controller.dart';

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
  //Initialize Controllers
  Get.put(AuthController());
  Get.put(DashboardController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flay Web Admin Panel',
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(),// AppTheme.appTheme,
      home: Auth(),
    );
  }
}
