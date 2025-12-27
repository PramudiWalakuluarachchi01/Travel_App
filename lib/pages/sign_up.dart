import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_app/services/database.dart';
import 'package:travel_app/services/shared_pref.dart';

import 'home.dart';
import 'sign_in.dart';

class SignUpUI extends StatefulWidget {
  const SignUpUI({super.key});

  @override
  State<SignUpUI> createState() => _SignUpUIState();
}

class _SignUpUIState extends State<SignUpUI> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 16, 16),
      body: SafeArea(
        child: Stack(
          children: [
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

                  const Center(
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Caveat',
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Center(
                    child: Text(
                      'Sign up to get started',
                      style: TextStyle(
                        fontSize: 24,
                        color: Color.fromARGB(255, 213, 213, 213),
                        fontFamily: 'Karla',
                      ),
                    ),
                  ),

                  const SizedBox(height: 240),

                  _buildTextField(
                    label: 'Name',
                    icon: Icons.person,
                    controller: _nameController,
                  ),

                  const SizedBox(height: 16),

                  _buildTextField(
                    label: 'Email',
                    icon: Icons.email,
                    controller: _emailController,
                  ),

                  const SizedBox(height: 16),

                  _buildPasswordField(
                    label: 'Password',
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    controller: _passwordController,
                    onToggle: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  _buildPasswordField(
                    label: 'Confirm Password',
                    icon: Icons.lock,
                    obscureText: _obscureConfirmPassword,
                    controller: _confirmPasswordController,
                    onToggle: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: GestureDetector(
                      onTap: _signUp,
                      child: ElevatedButton(
                        onPressed: _signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(
                                  milliseconds: 400,
                                ),
                                pageBuilder: (_, animation, __) =>
                                    const SignInUI(),
                                transitionsBuilder: (_, animation, __, child) {
                                  final tween = Tween(
                                    begin: const Offset(-1, 0),
                                    end: Offset.zero,
                                  ).chain(CurveTween(curve: Curves.easeInOut));

                                  return SlideTransition(
                                    position: animation.drive(tween),
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: const Text(
                            "Sign in",
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

  // ================= SIGN UP LOGIC =================

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showSnack('Please fill all fields');
      return;
    }

    if (password != confirmPassword) {
      _showSnack('Passwords do not match');
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Map<String, dynamic> userInfoMap = {
        'Name': name,
        'Email': email,
        'Id': userCredential.user!.uid,
        'Image':
            'https://www.google.com/search?sca_esv=0b6cd31ca70c40ac&rlz=1C1VDKB_enLK1167LK1167&sxsrf=AE3TifOU8LH-gCQKhmI87HeQOrT9_d1P6A:1766503551821&udm=2&fbs=AIIjpHxU7SXXniUZfeShr2fp4giZ1Y6MJ25_tmWITc7uy4KIeuYzzFkfneXafNx6OMdA4MQRJc_t_TQjwHYrzlkIauOKzdwwhoIZKJrCQTbRbErprPDqhqGfHcOcsQSxEAeABklaJVEszEvxPeJyeQPZx1hW0Gz0MoHLUwfeos5D6p5bBu6RrON6sdi6QETnpI9X3jF6V0WV7nK1AMv3mEiz5rjTscMOAQ&q=firebase&sa=X&ved=2ahUKEwiVm83FgtSRAxV-SGcHHWKWAIAQtKgLegQIIBAB&biw=1478&bih=892&dpr=1#sv=CAMSVhoyKhBlLWU5dlMyMmxRTlBmMXBNMg5lOXZTMjJsUU5QZjFwTToOUmJGUHRSQXB6Z2JWS00gBCocCgZtb3NhaWMSEGUtZTl2UzIybFFOUGYxcE0YADABGAcg1OfPnwUwAkoKCAIQAhgCIAIoAg',
      };

      final String id = userCredential.user!.uid;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        SharedPreferenceHelper.userEmailKey,
        _emailController.text,
      );
      await prefs.setString(
        SharedPreferenceHelper.userNameKey,
        _nameController.text,
      );
      await prefs.setString(SharedPreferenceHelper.userIdKey, id);
      await prefs.setString(
        SharedPreferenceHelper.userImageKey,
        'https://www.google.com/search?sca_esv=0b6cd31ca70c40ac&rlz=1C1VDKB_enLK1167LK1167&sxsrf=AE3TifOU8LH-gCQKhmI87HeQOrT9_d1P6A:1766503551821&udm=2&fbs=AIIjpHxU7SXXniUZfeShr2fp4giZ1Y6MJ25_tmWITc7uy4KIeuYzzFkfneXafNx6OMdA4MQRJc_t_TQjwHYrzlkIauOKzdwwhoIZKJrCQTbRbErprPDqhqGfHcOcsQSxEAeABklaJVEszEvxPeJyeQPZx1hW0Gz0MoHLUwfeos5D6p5bBu6RrON6sdi6QETnpI9X3jF6V0WV7nK1AMv3mEiz5rjTscMOAQ&q=firebase&sa=X&ved=2ahUKEwiVm83FgtSRAxV-SGcHHWKWAIAQtKgLegQIIBAB&biw=1478&bih=892&dpr=1#sv=CAMSVhoyKhBlLWU5dlMyMmxRTlBmMXBNMg5lOXZTMjJsUU5QZjFwTToOUmJGUHRSQXB6Z2JWS00gBCocCgZtb3NhaWMSEGUtZTl2UzIybFFOUGYxcE0YADABGAcg1OfPnwUwAkoKCAIQAhgCIAIoAg',
      );

      await DatabaseMethods().addUserDetails(userInfoMap, id).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Account created successfully!',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        );
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
            'Id': id,
            'Name': name,
            'Email': email,
            'CreatedAt': FieldValue.serverTimestamp(),
            'Image': '',
          });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnack(e.message ?? 'Something went wrong');
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ================= INPUT FIELDS =================

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 252, 252, 252)),
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
    required String label,
    required IconData icon,
    required bool obscureText,
    required TextEditingController controller,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      cursorColor: Colors.white,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color.fromARGB(255, 252, 252, 252)),
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 205, 205, 206)),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(255, 237, 237, 238),
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
