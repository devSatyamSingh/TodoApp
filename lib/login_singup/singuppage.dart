import 'dart:io';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/home/homepage.dart';
import 'package:todoapp/login_singup/loginpage.dart';

import '../providers/auth_provider.dart';


class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  // ================= CONTROLLERS =================
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  File? profileImage;
  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    nameCtrl.dispose();
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
                height: h * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan, Colors.cyanAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.note_alt,
                        color: Colors.white, size: w * 0.13),
                    Text(
                      "Create User Account",
                      style: TextStyle(
                        fontSize: w * 0.054,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Start your Task add in today",
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

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
                      children: [
                        TextFormField(
                          controller: nameCtrl,
                          cursorColor: Colors.cyan,
                          decoration: _inputDecoration(
                            "Full Name",
                            IconlyBold.profile,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return "Full name is required";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: h * 0.022),
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
                        SizedBox(height: h * 0.022),
                        TextFormField(
                          controller: passwordCtrl,
                          obscureText: true,
                          cursorColor: Colors.cyan,
                          decoration: _inputDecoration(
                            "Password",
                            Icons.lock,
                          ),
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
                          height: h * 0.055,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyan,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () {

                              if(_formKey.currentState!.validate()){

                                context.read<AuthProvider>().signup(
                                  context,
                                  nameCtrl.text.trim(),
                                  emailCtrl.text.trim(),
                                  passwordCtrl.text.trim(),
                                );
                              }

                            },
                            child: context.watch<AuthProvider>().loading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: w * 0.040,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: h * 0.012),

                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          child: const Text(
                            "Already a seller? Login",
                            style: TextStyle(
                              color: Colors.black87,
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

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontFamily: 'Poppins'),
      prefixIcon: Icon(icon),
      prefixIconColor: Colors.cyan,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
