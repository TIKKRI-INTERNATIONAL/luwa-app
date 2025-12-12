import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:async';

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    FocusScope.of(context).unfocus();
    
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
      String baseUrl = 'http://127.0.0.1:8080';
      if (!kIsWeb && Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8080';
      }

      debugPrint('Connecting to $baseUrl/api/auth/signup');

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      ).timeout(const Duration(seconds: 10));

      debugPrint('Response: ${response.statusCode} ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful!'),
            backgroundColor: Colors.green,
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          context.go('/');
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
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      if (mounted) {
        String message = 'Connection error';
        if (e is TimeoutException) {
          message = 'Connection timed out';
        } else if (e is SocketException) {
          message = 'Cannot connect to server';
        } else {
          message = 'Error: $e';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
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
                _buildTextField(label: 'Name', controller: _nameController),
                const SizedBox(height: 20),
                // Email field
                _buildTextField(label: 'Email', controller: _emailController),
                const SizedBox(height: 20),
                // Password field
                _buildTextField(label: 'Password', controller: _passwordController, obscureText: true),
                const SizedBox(height: 40),
                // Register Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 20),
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
                        context.go('/');
                      },
                      child: Text(
                        'Log In',
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
}
