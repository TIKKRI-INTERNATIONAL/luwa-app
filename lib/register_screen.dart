import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.menu, color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Divider(color: Colors.black54),
            const SizedBox(height: 30),
            _buildTextField(label: 'User Name'),
            const SizedBox(height: 20),
            _buildTextField(label: 'Password', obscureText: true),
            const SizedBox(height: 20),
            _buildTextField(label: 'Email'),
            const SizedBox(height: 20),
            _buildTextField(label: 'Bank Ipan'),
            const SizedBox(height: 20),
            _buildTextField(label: 'Phone No'),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Save',
                style: GoogleFonts.notoSerif(fontSize: 18),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildOutlinedButton(context, 'Edit Store'),
                _buildOutlinedButton(context, 'Edit Auction'),
              ],
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.black54),
          ],
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

  Widget _buildOutlinedButton(BuildContext context, String text) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC3BCAE),
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: const BorderSide(color: Colors.black54, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
      ),
      child: Text(
        text,
        style: GoogleFonts.notoSerif(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}
