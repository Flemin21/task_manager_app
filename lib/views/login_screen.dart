import 'package:flutter/material.dart';

import '../services/login_manager.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    LoginManager loginManager = LoginManager();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final _formkey = GlobalKey<FormState>();
    bool obscureText = true;

    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock, size: 80, color: Colors.blue),
                const SizedBox(height: 20),
        
                const SizedBox(height: 30),
        
                TextFormField(

                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(height: 25),
        
                TextFormField(
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
                          onPressed: () {}
                  ),
                ),
                ),
                 SizedBox(height: 20),
        
                SizedBox(
                  height: 40,
                  width: 300,
                  child: ElevatedButton(
                    onPressed: () async{
                      if(_formkey.currentState!.validate()){
                       bool login = await loginManager.saveUserLoginData(username: emailController.text, password: passwordController.text);
                        if(login){
                          emailController.clear();
                          passwordController.clear();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
                            return HomeScreen();
                          } ));
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login pressed")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white
                    ),
                    child: const Text("Login",style: TextStyle(fontSize: 20),),
                  ),
                ),
                const SizedBox(height: 10),
        
                TextButton(
                  onPressed: () {},
                  child: const Text("Don’t have an account? Sign Up",style: TextStyle(color: Colors.black),),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}