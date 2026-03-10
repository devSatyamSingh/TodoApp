import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/task_provider.dart';
import 'providers/auth_provider.dart';
import 'splashscreen.dart';
import 'login_singup/loginpage.dart';
import 'login_singup/singuppage.dart';
import 'home/homepage.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [

        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskProvider(),
        ),

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: "Todo App",

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
      ),

      routes: {

        "/": (context) => SplashScreen(),
        "/login": (context) => LoginPage(),
        "/signup": (context) => SignupPage(),
        "/home": (context) => HomePages(),

      },
      initialRoute: "/",
    );
  }
}