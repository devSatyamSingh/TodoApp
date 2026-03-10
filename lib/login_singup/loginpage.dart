import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/home/homepage.dart';
import 'package:todoapp/login_singup/singuppage.dart';

import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  // ================= CONTROLLERS =================
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER =================
              Container(
                height: h * 0.32,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.cyanAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_alt, color: Colors.white, size: w * 0.16),
                    Text(
                      "Todo App",
                      style: TextStyle(
                        fontSize: w * 0.060,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Manage Task In This Application",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),

              // ================= FORM CARD =================
              Transform.translate(
                offset: const Offset(0, -40),
                child: Container(
                  width: w * 0.9,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: w * 0.050,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: h * 0.020),

                        // -------- EMAIL --------
                        TextFormField(
                          controller: emailCtrl,
                          cursorColor: Colors.cyan,
                          keyboardType: TextInputType.emailAddress,
                          decoration: _inputDecoration(
                            "Email address",
                            Icons.email,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return "Email is required";
                            }
                            if (!v.contains("@")) {
                              return "Enter a valid email";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: h * 0.028),

                        // -------- PASSWORD --------
                        TextFormField(
                          controller: passwordCtrl,
                          obscureText: true,
                          cursorColor: Colors.cyan,
                          decoration: _inputDecoration("Password", Icons.lock),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return "Password is required";
                            }
                            if (v.length < 6) {
                              return "Minimum 6 characters required";
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: h * 0.028),
                        SizedBox(
                          width: double.infinity,
                          height: h * 0.056,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                context.read<AuthProvider>().login(
                                  context,
                                  emailCtrl.text.trim(),
                                  passwordCtrl.text.trim(),
                                );
                              }

                            },
                            child: context.watch<AuthProvider>().loading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              "LOGIN",
                              style: TextStyle(
                                fontSize: w * 0.039,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: h * 0.018),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupPage(),
                                ),
                              );
                            },
                            child: Text(
                              "New User? Create account",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= UI HELPER =================
  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Poppins'),
      prefixIcon: Icon(icon),
      prefixIconColor: Colors.cyan,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
