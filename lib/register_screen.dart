import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:myapp/login_screen.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';

import 'dart:async'; // Add this import

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _bankIpanController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bankIpanController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Validate inputs
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Use 127.0.0.1 instead of localhost for better compatibility on iOS Simulator
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }

      debugPrint('Connecting to $baseUrl/api/auth/signup');

      final response = await http
          .post(
            Uri.parse('$baseUrl/api/auth/signup'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'name': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'password': _passwordController.text,
              'userType': 'USER',
            }),
          )
          .timeout(const Duration(seconds: 10));

      debugPrint('Response Status: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.body == "Email is already in use!") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email is already in use!'),
              backgroundColor: Colors.red,
            ),
          );
          // return;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful sdsdsdfsdfsdfsd'),
              backgroundColor: Colors.green,
            ),
          );
          // Small delay to let the user see the success message
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          }
        }
      } else {
        String errorMessage = 'Registration failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (_) {
          errorMessage = 'Server error: ${response.statusCode}';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      if (mounted) {
        String message = 'Connection error';
        if (e is TimeoutException) {
          message = 'Connection timed out. Check your server.';
        } else if (e is SocketException) {
          message =
              'Cannot connect to server. Check your internet or server URL.';
        } else {
          message = 'Error: $e';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
            _buildTextField(label: 'User Name', controller: _nameController),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),
            const SizedBox(height: 20),
            _buildTextField(label: 'Email', controller: _emailController),
            const SizedBox(height: 20),
            _buildTextField(
              label: 'Bank Ipan',
              controller: _bankIpanController,
            ),
            const SizedBox(height: 20),
            _buildTextField(label: 'Phone No', controller: _phoneController),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Register',
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

  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
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
