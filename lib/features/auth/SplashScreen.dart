import 'package:flutter/material.dart';
import 'package:task_tracker_mobile_app/features/auth/sign_in_Screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      // Navigate to home or login screen
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A), // Navy/dark background
      body: Stack(
        children: [
          // Optional Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/backgroundImage.png',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.4),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Logo and App Name
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Image.asset(
                  'assets/taskTrackerAppLogo.png',
                  height: 120,
                  width: 120,
                ),
                const SizedBox(height: 20),

                // App Name
                const Text(
                  "Task Tracker",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),

                // Tagline or Subtitle
                const SizedBox(height: 10),
                const Text(
                  "Organize • Track • Deliver",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 1.5,
                  ),
                )
              ],
            ),
          ),

          // Bottom credit or powered by
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Empowering Productivity",
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
