import 'package:flutter/material.dart';
import 'features/admin_panel/All_Employee_Task_Screen.dart';
import 'features/admin_panel/admin_dashboard_Screen.dart';
import 'features/auth/SplashScreen.dart';
import 'features/auth/sign_in_Screen.dart';
import 'features/user_panel/task_submission_form_Screen.dart';
import 'features/user_panel/user_dashboard_Screen.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print("Successfully Login");
  }catch(e){
    print("System Failed ${e}");
  }
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
    return MaterialApp(
        navigatorKey: navigatorKey, // ✅ Set here
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: Splashscreen()
    );
  }
}

