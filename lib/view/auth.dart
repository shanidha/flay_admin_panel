
import 'package:flay_admin_panel/view/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import 'login_screen.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      //Reactive Management to handle authentication pages
      return AuthController.to.user.value == null
        ? const LoginScreen()
        :  Dashboard();
    });
  }
}