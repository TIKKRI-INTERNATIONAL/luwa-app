import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      // Check if the widget is still in the tree before navigating
      if (mounted && context.mounted) {
        context.go('/signup');
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAE8E1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.spa, size: 40, color: Colors.black),
                const SizedBox(width: 5),
                Transform.flip(
                  flipX: true,
                  child: const Icon(Icons.spa, size: 40, color: Colors.black),
                ),
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEAE8E1), width: 2),
                  ),
                  child: const Icon(
                    Icons.gavel_sharp,
                    size: 60,
                    color: Color(0xFFEAE8E1),
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.spa, size: 40, color: Colors.black),
                const SizedBox(width: 5),
                Transform.flip(
                  flipX: true,
                  child: const Icon(Icons.spa, size: 40, color: Colors.black),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'BOX BEE',
              style: GoogleFonts.notoSerif(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}