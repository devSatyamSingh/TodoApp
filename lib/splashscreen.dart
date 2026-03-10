import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnim;
  late Animation<double> fadeAnim;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    scaleAnim = Tween<double>(begin: 0.6, end: 1.1).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeOutBack),
    );

    fadeAnim = Tween<double>(begin: 0, end: 1).animate(controller);

    controller.forward();

    checkLogin();
  }

  Future checkLogin() async {

    await Future.delayed(Duration(seconds: 4));

    SharedPreferences prefs =
    await SharedPreferences.getInstance();

    bool? isLogin = prefs.getBool("isLogin");

    if(isLogin == true){

      Navigator.pushReplacementNamed(context, "/home");

    }else{

      Navigator.pushReplacementNamed(context, "/signup");

    }

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(

        width: double.infinity,
        height: double.infinity,

        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.cyan, Colors.cyanAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: FadeTransition(
          opacity: fadeAnim,
          child: ScaleTransition(
            scale: scaleAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage("assets/images/todologo.png"),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Todo App",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Manage Your Task In This App",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}