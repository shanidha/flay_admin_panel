import 'package:flay_admin_panel/controller/dashboard_controller.dart';
import 'package:flay_admin_panel/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main() async {
  Get.put(DashboardController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flay Web Admin Panel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Dashboard(),
    );
  }
}
