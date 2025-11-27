import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

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
                const SizedBox(height: 70),
                // Title
                Text(
                  'Verification Code',
                  style: GoogleFonts.notoSerif(
                    fontSize: 32,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 40),
                // OTP Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpBox('1'),
                    _buildOtpBox('6'),
                    _buildOtpBox('3'),
                    _buildOtpBox('7'),
                  ],
                ),
                const SizedBox(height: 40),
                // Complete Button
                ElevatedButton(
                  onPressed: () => GoRouter.of(context).go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
                  ),
                  child: Text(
                    'Complete',
                    style: GoogleFonts.notoSerif(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 30),
                // Check your email text
                Text(
                  'Check your Email',
                  style: GoogleFonts.notoSerif(
                    fontSize: 24,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpBox(String text) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black, width: 1.5),
      ),
      child: Center(
        child: Text(
          text,
          style: GoogleFonts.notoSerif(fontSize: 24, color: Colors.black87),
        ),
      ),
    );
  }
}
