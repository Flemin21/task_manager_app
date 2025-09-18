import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../services/login_manager.dart';
import '../utils/validator.dart';
import '../widgets/app_button.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginManager loginManager = LoginManager();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool obscureText = true;
  Validator validator = Validator();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Icon(Icons.lock, size: 80.sp, color: Colors.blue),
                 SizedBox(height: 20.h),

                TextFormField(
                  controller: emailController,
                  validator: Validator.emailValidation,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                 SizedBox(height: 25.h),

                TextFormField(
                  validator: Validator.passwordValidation,
                  controller: passwordController,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                  ),
                ),
                 SizedBox(height: 20.h),

                SizedBox(
                  height: 40.h,
                  width: 300.w,
                  child:   AppButton(
                    buttonText: "Login",
                    buttonColor: Colors.black,
                    textColor: Colors.white,
                    borderRadius: 8.0,
                    padding: EdgeInsets.all(8.0),
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        bool login = await loginManager.saveUserLoginData(
                          username: emailController.text,
                          password: passwordController.text,
                        );
                        if (login) {
                          emailController.clear();
                          passwordController.clear();
                          context.go('/home');
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Logged In")),
                        );
                      }
                    }, 
                  ),
                ),
                 SizedBox(height: 10.h),

                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Don’t have an account? Sign Up",
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
