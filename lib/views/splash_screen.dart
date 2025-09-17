import 'dart:async';

import 'package:flutter/material.dart';
import 'package:task_manager_app/services/login_manager.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  LoginManager loginManager = LoginManager();

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await loginManager.isLoggedIn();

    if(isLoggedIn == true){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
        return HomeScreen();
      } ));
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) {
        return LoginScreen();
      } ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 3),(){
      _checkLoginStatus();
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo/task_manager_logo.jpg",
          height: 200,
          width: 200,
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
