// ignore_for_file: unused_import
import 'package:flutter/material.dart';//package ma
import 'splash_screen.dart';
import 'login.dart';
import 'signup_page.dart';
void main() {
  runApp(const FitmeApp()); //MYAPP -->DEFULT
}
class FitmeApp extends StatelessWidget {//CLASS  IDENTIFY
  const FitmeApp({super.key});
  @override   //:  INHERITANCE
  Widget build(BuildContext context) {
    return MaterialApp(   ///method 
      title: 'Fitme360',
      debugShowCheckedModeBanner: false, 
   
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/splash': (context) => const SplashScreen(),
      },
    );
  }
}
