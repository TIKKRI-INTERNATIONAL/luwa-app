import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/otp_screen.dart';

class UserRegisterScreen extends StatelessWidget {
  const UserRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE8E1),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.spa, size: 30, color: Colors.black),
                    const SizedBox(width: 5),
                    Transform.flip(
                      flipX: true,
                      child: const Icon(Icons.spa, size: 30, color: Colors.black),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFEAE8E1), width: 2),
                      ),
                      child: const Icon(
                        Icons.gavel_sharp,
                        size: 40,
                        color: Color(0xFFEAE8E1),
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Icon(Icons.spa, size: 30, color: Colors.black),
                    const SizedBox(width: 5),
                    Transform.flip(
                      flipX: true,
                      child: const Icon(Icons.spa, size: 30, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                // Title
                Text(
                  'Sign Up Now',
                  style: GoogleFonts.notoSerif(
                    fontSize: 36,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),
                // Name field
                _buildTextField(label: 'Name'),
                const SizedBox(height: 20),
                // Email field
                _buildTextField(label: 'Email'),
                const SizedBox(height: 20),
                // Password field
                _buildTextField(label: 'Password', obscureText: true),
                const SizedBox(height: 40),
                // Register Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const OTPScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  ),
                  child: Text(
                    'Register',
                    style: GoogleFonts.notoSerif(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                // Login text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "I have an account! ",
                      style: GoogleFonts.notoSerif(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Log in',
                        style: GoogleFonts.notoSerif(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, bool obscureText = false}) {
    return TextField(
      obscureText: obscureText,
      textAlign: TextAlign.center,
      style: GoogleFonts.notoSerif(fontSize: 18),
      decoration: InputDecoration(
        hintText: label,
        hintStyle: GoogleFonts.notoSerif(color: Colors.black54, fontSize: 18),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
        ),
      ),
    );
  }
}
