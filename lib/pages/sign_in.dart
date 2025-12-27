import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/services/database.dart';
import 'package:travel_app/services/shared_pref.dart';

import 'home.dart';
import 'sign_up.dart';

class SignInUI extends StatefulWidget {
  SignInUI({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  State<SignInUI> createState() => _SignInUIState();
}

class _SignInUIState extends State<SignInUI> {
  String email = "", password = "", myname = "", myid = '', myimage = '';

  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 16, 16),
      body: SafeArea(
        child: Stack(
          children: [
            // Top image with opacity
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: 0.35,
                child: Image.asset(
                  'assets/images/travel.jpg',
                  height: 600,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Caveat',
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: const Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 213, 213, 213),
                        fontFamily: 'Karla',
                      ),
                    ),
                  ),

                  const SizedBox(height: 370),

                  _buildTextField(
                    controller: widget._emailController,
                    label: 'Email',
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 16),
                  _buildPasswordField(
                    controller: widget._passwordController,
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    onToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  const SizedBox(height: 4),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO: Add Forgot Password UI here
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 3),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        String email = widget._emailController.text.trim();
                        String password = widget._passwordController.text
                            .trim();

                        if (email.isEmpty || password.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please fill all fields'),
                            ),
                          );
                          return;
                        }

                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          QuerySnapshot snapshot = await DatabaseMethods()
                              .getUserbyEmail(email);

                          if (snapshot.docs.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("User data not found"),
                              ),
                            );
                            return;
                          }

                          final userData = snapshot.docs.first;

                          myname = userData['Name'] ?? '';
                          myid = userData['Id'] ?? '';
                          myimage = userData['Image'] ?? '';

                          final prefs = await SharedPreferences.getInstance();

                          await prefs.setString(
                            SharedPreferenceHelper.userImageKey,
                            myimage,
                          );
                          await prefs.setString(
                            SharedPreferenceHelper.userNameKey,
                            myname,
                          );
                          await prefs.setString(
                            SharedPreferenceHelper.userEmailKey,
                            email,
                          );
                          await prefs.setString(
                            SharedPreferenceHelper.userIdKey,
                            myid,
                          );

                          // Navigate to Home
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Home(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          String message = '';
                          if (e.code == 'user-not-found') {
                            message = 'No user found for this email.';
                          } else if (e.code == 'wrong-password') {
                            message = 'Incorrect password.';
                          } else {
                            message = e.message.toString();
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 400,
                                ),
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        SignUpUI(),
                                transitionsBuilder:
                                    (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      const begin = Offset(1.0, 0.0);
                                      const end = Offset.zero;
                                      const curve = Curves.easeInOut;

                                      final tween = Tween(
                                        begin: begin,
                                        end: end,
                                      ).chain(CurveTween(curve: curve));
                                      final offsetAnimation = animation.drive(
                                        tween,
                                      );

                                      return SlideTransition(
                                        position: offsetAnimation,
                                        child: child,
                                      );
                                    },
                              ),
                            );
                          },
                          child: const Text(
                            "Sign up",
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 205, 205, 206)),
        filled: true,
        fillColor: const Color.fromARGB(255, 110, 113, 115),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),

      cursorColor: Colors.white,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 205, 205, 206)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.white,
          ),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 110, 113, 115),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
