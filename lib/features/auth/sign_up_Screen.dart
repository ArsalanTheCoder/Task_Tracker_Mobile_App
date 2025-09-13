import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_tracker_mobile_app/features/auth/sign_in_Screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordContoller = TextEditingController();
  TextEditingController confirmPassContoller = TextEditingController();

  void _showFlushbar(String message) {
    Flushbar(
      title: "Hi there!",
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


  Future<void> Registration() async {
    final email = emailController.text.trim();
    final password = passwordContoller.text.trim();
    final confirmPassword = confirmPassContoller.text.trim();

    // Validate input
    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showFlushbar("Please fill all fields");
      return;
    }

    if (password != confirmPassword) {
      _showFlushbar("Both passwords must be the same!");
      return;
    }

    // Show loading feedback (optional)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Firebase registration
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user role in Firestore
      await FirebaseFirestore.instance
          .collection('users_decision')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'role': 'user',
        "Name": nameController.text.trim()
      });

      Navigator.of(context).pop(); // Close loading spinner

      // Show success message
      await Flushbar(
        message: "Registration Successful!",
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

      // Small delay so user can read message
      await Future.delayed(const Duration(milliseconds: 300));

      // Navigate to login screen
      Navigator.pop(context);

    } on FirebaseAuthException catch (e) {
      Navigator.of(context).pop(); // Close loading spinner
      _showFlushbar(e.message ?? "Registration failed. Try again.");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
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
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      child: Column(
                        children: [
                          const Text(
                            "Registration",
                            style: TextStyle(
                              fontSize: 35,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // 🔹 Custom Text Fields
                          CustomTextField(
                            title: "User Name",
                            hint: "User name",
                            controller: nameController,
                          ),
                          CustomTextField(
                            title: "Email",
                            hint: "Email Address",
                            controller: emailController,
                          ),
                          CustomTextField(
                            title: "Password",
                            hint: "Password",
                            controller: passwordContoller,
                            isPassword: true,

                          ), CustomTextField(
                            title: "Password",
                            hint: "Confirm Password",
                            controller: confirmPassContoller,
                            isPassword: true,
                          ),

                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () async {
                              await Registration();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Signup", style: TextStyle(fontSize: 20, color: Colors.white)),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              SizedBox(width: 10),
                              Container(
                                  height: 1,
                                  width: 100,
                                  color: Colors.white70
                              ),
                              SizedBox(width: 5),
                              Text("Or Signup with", style: TextStyle(color: Colors.white70)),
                              SizedBox(width: 5),
                              Container(
                                  height: 1,
                                  width: 100,
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
                          SizedBox(height: 10),
                          Row(
                            children: [
                              SizedBox(width: 50),
                              Text("Already have an account?", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                              TextButton(
                                  onPressed: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                                  }, child: Text("Login", style: TextStyle(fontWeight: FontWeight.bold),))
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
      padding: const EdgeInsets.symmetric(vertical: 8),
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
          SizedBox(height: 4),
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
