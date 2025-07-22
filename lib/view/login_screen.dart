import 'package:flay_admin_panel/core/resources/app_colors.dart';
import 'package:flay_admin_panel/core/resources/app_fonts.dart';
import 'package:flay_admin_panel/core/resources/app_images.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      await AuthController.to.signIn(
        _emailCtrl.text.trim(),
        _passwordCtrl.text,
      );

      // Get.offAll(() =>  Dashboard());
    } on Exception catch (e) {
      Get.snackbar('Login Failed', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Column(
            children: [
              // — Logo
              SvgPicture.asset(
                AppVectors.flayWhite,
                width: 200,
              ),
              const SizedBox(height: 32),
              Container(
                width: 500,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // — Header Text
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Enter your credentials to access your account',
                        style: TextStyle(color: Colors.black54, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 24),

                      // — Email Field
                      _buildEmailField(),

                      const SizedBox(height: 16),

                      // — Password Field
                      _buildPasswordField(),

                      const SizedBox(height: 8),

                      // — Reset Password link
                      _buildPasswordResetLink(),

                      const SizedBox(height: 16),

                      // — Sign In button
                      _buildSignInButton(),

                      const SizedBox(height: 24),

                      // — Bottom prompt
                      _buildSignUpBottomPrompt()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
   color: AppColors.background,        
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,  
        offset: const Offset(1, 1),      
        blurRadius: 4,                      
      )
    ],
      ),
      
    child: TextFormField(
      style: TextStyle(color: AppColors.secondBackground),
          controller: _emailCtrl,
          keyboardType: TextInputType.emailAddress,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'Email required';
            if (!v.contains('@')) return 'Invalid email';
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your email',  hintStyle: TextStyle(color: AppColors.kHintStyle),
            prefixIcon: Padding(
      padding: const EdgeInsets.all(8),             
      child: SvgPicture.asset(
        AppVectors.email,
        width: 20,                             
        height: 20,
      ),
    ),
    prefixIconConstraints: const BoxConstraints(
      minWidth: 32,                                
      minHeight: 32,
    ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
  );
  Widget _buildPasswordField() => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
   color: AppColors.background,        
    boxShadow: [
      BoxShadow(
        color: AppColors.shadowColor,  
        offset: const Offset(1, 1),      
        blurRadius: 4,                      
      )
    ],
      ),
    child: TextFormField( style: TextStyle(color: AppColors.secondBackground),
          controller: _passwordCtrl,
          obscureText: true,
          validator: (v) {
            if (v == null || v.isEmpty) return 'Password required';
            if (v.length < 6) return 'At least 6 characters';
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Enter your password',
            hintStyle: TextStyle(color: AppColors.kHintStyle),
             prefixIcon: Padding(
      padding: const EdgeInsets.all(8),             
      child: SvgPicture.asset(
        AppVectors.lock,
        width: 20,                             
        height: 20,
      ),
    ),
    prefixIconConstraints: const BoxConstraints(
      minWidth: 32,                                
      minHeight: 32,
    ),
            filled: true,
            fillColor: AppColors.background,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
  );
  Widget _buildPasswordResetLink() => Align(
        alignment: Alignment.centerRight,
        child: TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            splashFactory: NoSplash.splashFactory,
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
          ),
          child: const Text(
            'Reset password',
            style: TextStyle(
              color: AppColors.kBlueColor,
              fontSize: 13,
            ),
          ),
        ),
      );
  Widget _buildSignInButton() => SizedBox(
        width: 300,
        height: 55,
        child: ElevatedButton(
          onPressed: _loading ? null : _onSignIn,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            elevation: 0,
          ),
          child: _loading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                      color: Colors.white, strokeWidth: 2),
                )
              : const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      );
  Widget _buildSignUpBottomPrompt() => RichText(
        text: TextSpan(
          text: "Don't have an account yet? ",
          style: const TextStyle(color: AppColors.secondBackground),
          children: [
            TextSpan(
              text: 'Join us on Flay',
              style: const TextStyle(
                fontFamily: FontConstants.fontFamily,
                color:AppColors.kBlueColor,
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Get.to(() => const SignupScreen());
                },
            ),
          ],
        ),
      );
}
