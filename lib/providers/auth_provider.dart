import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool loading = false;

  Future login(BuildContext context, String email, String password) async {
    try {
      loading = true;
      notifyListeners();

      final user = await _authService.login(email, password);

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setBool("isLogin", true);

        Navigator.pushReplacementNamed(context, "/home");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }

    loading = false;
    notifyListeners();
  }

  Future logout(BuildContext context) async {
    try {

      loading = true;
      notifyListeners();

      await _authService.logout();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove("isLogin");
      prefs.remove("userName");

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/",
            (route) => false,
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Logout Failed"))
      );

    }

    loading = false;
    notifyListeners();
  }

  Future signup(BuildContext context, String name,String email, String password) async {

    try {

      loading = true;
      notifyListeners();

      final user = await _authService.signup(email, password);

      if (user != null) {

        SharedPreferences prefs =
        await SharedPreferences.getInstance();

        /// user name save
        prefs.setString("userName", name);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Account Created Successfully"))
        );

        Navigator.pushReplacementNamed(context, "/login");

      }

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()))
      );

    }

    loading = false;
    notifyListeners();
  }
}
