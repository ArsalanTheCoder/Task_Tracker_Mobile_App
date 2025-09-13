import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_tracker_mobile_app/features/admin_panel/admin_dashboard_Screen.dart';
import 'package:task_tracker_mobile_app/features/auth/sign_up_Screen.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_tracker_mobile_app/features/user_panel/user_dashboard_Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void _showFlushbar(String message) {
    Flushbar(
      title: "Hi, there!",
      message: message,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.error_outline, color: Colors.white, size: 28),
      backgroundColor: Theme.of(context).primaryColor,
      titleColor: Colors.white,
      messageColor: Colors.white,
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(12),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      animationDuration: const Duration(milliseconds: 500),
      forwardAnimationCurve: Curves.easeOut,
      boxShadows: const [
        BoxShadow(
          color: Colors.black26,
          offset: Offset(0, 4),
          blurRadius: 8,
        )
      ],
    ).show(context);
  }


  Future<void> Login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 🔍 Input Validation
    if (email.isEmpty || password.isEmpty) {
      _showFlushbar("Please fill all fields");
      return;
    }

    // 🔄 Show loading while authenticating
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 🔐 Sign in user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // 🔍 Fetch user role from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users_decision')
          .doc(uid)
          .get();

      Navigator.of(context).pop(); // Close loading dialog

      if (!userDoc.exists || !userDoc.data()!.containsKey('role')) {
        throw FirebaseAuthException(
          message: "User role not found.",
          code: 'role-not-found',
        );
      }

      final role = userDoc['role'];

      // ✅ Show success Flushbar
      await Flushbar(
        message: "Login Successful!",
        duration: const Duration(seconds: 2),
        icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 28),
        backgroundColor: Colors.green.shade600,
        messageColor: Colors.white,
        flushbarPosition: FlushbarPosition.TOP,
        borderRadius: BorderRadius.circular(12),
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(16),
        animationDuration: const Duration(milliseconds: 500),
        forwardAnimationCurve: Curves.easeOut,
        boxShadows: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 4),
            blurRadius: 8,
          )
        ],
      ).show(context);

      // 🎯 Navigate based on role
      await Future.delayed(const Duration(milliseconds: 300));
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          role == 'admin' ? AdminDashboardScreen() : UserDashboardScreen(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close loading dialog if open

      _showFlushbar(e.message ?? "An unknown error occurred.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand( // ✅ Makes sure Stack fills full screen
        child: Stack(
          children: [
            // 🔹 Background Image
            Positioned.fill(
              child: Image.asset(
                'assets/backgroundImage.png',
                fit: BoxFit.cover,
              ),
            ),

            // 🔹 Black Overlay
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),

            // 🔹 Scrollable Content
            Positioned.fill(
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Column(
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),

                          // 🔹 Custom Text Fields
                          CustomTextField(
                            title: "Email",
                            hint: "Email Address",
                            controller: emailController,
                          ),
                          CustomTextField(
                            title: "Password",
                            hint: "Password",
                            controller: passwordController,
                            isPassword: true,
                          ),
                          Row(
                            children: [
                              SizedBox(width: 180),
                              TextButton(
                                  onPressed: (){
                                    // logic
                                  }, child: Text("Forgot password?", style: TextStyle(color: Colors.white30, decoration: TextDecoration.underline)))

                            ],
                          ),

                          // 🔹
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async{
                              await Login();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 130, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Login", style: TextStyle(fontSize: 20, color: Colors.white)),
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Container(
                                height: 1,
                                width: 105,
                                color: Colors.white70
                              ),
                              SizedBox(width: 5),
                              Text("Or login with", style: TextStyle(color: Colors.white70)),
                              SizedBox(width: 5),
                              Container(
                                  height: 1,
                                  width: 105,
                                  color: Colors.white70
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(width: 15),
                              CustomIcon(FontAwesomeIcons.google),
                              SizedBox(width: 10),
                              CustomIcon(FontAwesomeIcons.apple),
                              SizedBox(width: 10),
                              CustomIcon(FontAwesomeIcons.facebook),
                            ],
                          ),
                          SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(width: 50),
                              Text("Don't have an account?", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                              TextButton(
                                  onPressed: (){
                                     Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                                  },
                                  child: Text("SignUp",
                                    style: TextStyle(fontWeight: FontWeight.bold),))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



Widget CustomIcon(IconData icon) {
  return SizedBox(
    height: 60,
    width: 90,
    child: Card(
      elevation: 8,
      color: Colors.white70, // or light grey if you prefer
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 30,
          color: Colors.black87,
        ),
      ),
    ),
  );
}



class CustomTextField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController controller;
  final bool isPassword;

  const CustomTextField({
    super.key,
    required this.title,
    required this.hint,
    required this.controller,
    this.isPassword = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}
class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            obscureText: widget.isPassword ? _obscureText : false,
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: const TextStyle(color: Colors.black54),
              filled: true,
              fillColor: Colors.white70, // ✅ Light white/grey background
              suffixIcon: widget.isPassword
                  ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
                  : null,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
