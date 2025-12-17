
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    FocusScope.of(context).unfocus();

    if (_emailController.text.trim().isEmpty ||
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

      debugPrint('Connecting to $baseUrl/api/auth/login');

      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      ).timeout(const Duration(seconds: 10));

      debugPrint('Response: ${response.statusCode} ${response.body}');

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String token = data['token'];
        int userId = data['id'];
        String userType = data['userType'];
        String name = data['name'];
        String email = data['email'];
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setInt('user_id', userId);
        await prefs.setString('user_type', userType);
        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );
        
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          context.go('/home');
        }
      } else {
        String errorMessage = 'Login failed';
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
      debugPrint('Error during login: $e');
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
                  'please Login to continue using app',
                  style: GoogleFonts.notoSerif(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 30),
                // Email field
                _buildTextField(label: 'Email', controller: _emailController),
                const SizedBox(height: 20),
                // Password field
                _buildTextField(label: 'Password', controller: _passwordController, obscureText: true),
                const SizedBox(height: 30),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                              'Log in',
                              style: GoogleFonts.notoSerif(fontSize: 18),
                            ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'Forgot Password',
                        style: GoogleFonts.notoSerif(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                // Sign up text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have an account? ",
                      style: GoogleFonts.notoSerif(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.push('/user-register');
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.notoSerif(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Connect with text
                Text(
                  'Or Connect with',
                  style: GoogleFonts.notoSerif(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
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
