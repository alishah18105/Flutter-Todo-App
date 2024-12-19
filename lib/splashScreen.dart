
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo_project/data/functions.dart';
import 'package:todo_project/homepage.dart';
import 'package:todo_project/loginScreen.dart';
import 'package:todo_project/utilis/app_colors.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
@override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      String? emailAdress = LocalStorage.getString("email");
      if (emailAdress == null ) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10)
          ),
          child: Lottie.asset("assets/images/todoSplashScreen.json"),
          width: 300,
        ),
      ),
    )
     ;
  }
}