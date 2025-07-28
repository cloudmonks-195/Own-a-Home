import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize Animation Controller for Zoom In/Out Effect
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Total duration for effect
      lowerBound: 0.9, // Min scale (slightly smaller)
      upperBound: 1.1, // Max scale (slightly larger)
    )..repeat(reverse: true); // Repeats with reverse effect

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);

    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash screen delay
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      ); // Navigate to home screen if logged in
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ); // Navigate to login screen if not logged in
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller to free resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 212, 20, 90), // 🔴 Red
              Color.fromARGB(255, 251, 176, 59), // 🟠 Orange
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: ScaleTransition(
            scale: _animation, // Apply Zoom In/Out Effect
            child: Image.asset(
              'assets/image/download.png', // Replace with your image asset
              width: 150,
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}
