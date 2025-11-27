import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/register_screen.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                const SizedBox(height: 30),
                // Welcome Text
                Text(
                  'Welcome to',
                  style: GoogleFonts.notoSerif(
                    fontSize: 28,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'BOX BEE',
                  style: GoogleFonts.notoSerif(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  'Auction',
                  style: GoogleFonts.notoSerif(
                    fontSize: 28,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 50),
                // Get Started Button
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC3BCAE),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: GoogleFonts.notoSerif(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Login Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Do you have an account? ',
                      style: GoogleFonts.roboto(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Log in',
                        style: GoogleFonts.roboto(
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
}
