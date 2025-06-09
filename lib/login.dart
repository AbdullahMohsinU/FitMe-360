// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;  //abbdd  -->........
import 'database_helper.dart';
import 'dashboard.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});///-(state change)->username email--->password  

  @override///_(private)
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> { //const ,final  const ->  ,final ->
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();//predefined
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _passwordFocusNode = FocusNode();
  String _passwordDisplay = ''; // Displayed as obscured or actual characters
  bool _isPasswordVisible = false; // Toggle for password visibility
  int _loginAttempts = 0;
  bool _isLocked = false;
  DateTime? _lastAttemptTime;

  // Encryption key for secure storage
  final _encrypter = encrypt.Encrypter(encrypt.AES(encrypt.Key.fromLength(32)));

  String _hashPassword(String password) {//.........
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);///->
    return digest.toString();
  }

  Future<void> _storeEncryptedCredentials(String email, String password, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();//shared preferene data abc@gmail.com  abc
    final iv = encrypt.IV.fromLength(16);

    // Encrypt sensitive data
    final encryptedEmail = _encrypter.encrypt(email, iv: iv).base64;
    final encryptedPassword = _encrypter.encrypt(_hashPassword(password), iv: iv).base64;

    await prefs.setString('encrypted_email', encryptedEmail);
    await prefs.setString('encrypted_password', encryptedPassword);
    await prefs.setString('iv', iv.base64);

    if (user['name'] != null) {
      final encryptedName = _encrypter.encrypt(user['name'], iv: iv).base64;
      await prefs.setString('encrypted_name', encryptedName);
    }
    if (user['profile_image'] != null) {
      await prefs.setString('profile_image', user['profile_image']);
    }
  }//

  String? _sanitizeInput(String? input) {
    if (input == null) return null;
    // Basic sanitization to prevent injection
    final sanitized = input.replaceAll(RegExp(r'[<>;{}]'), '').trim();
    return sanitized.isEmpty ? null : sanitized;
  }

  Future<void> _login() async {
    // Custom rate limiting: max 5 attempts per minute
    final now = DateTime.now();
    if (_isLocked) {
      if (_lastAttemptTime != null && now.difference(_lastAttemptTime!).inMinutes < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Too many attempts. Please wait a minute.')),
        );
        return;
      } else {
        setState(() {
          _isLocked = false;
          _loginAttempts = 0;
        });
      }
    }

    if (_formKey.currentState!.validate()) {
      try {
        String email = _sanitizeInput(emailController.text) ?? '';
        String password = _sanitizeInput(passwordController.text) ?? '';

        if (email.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid input')),
          );
          return;
        }
///--->Databse
        final user = await DatabaseHelper().getUser(email, _hashPassword(password));

        if (user != null) {
          _loginAttempts = 0;
          _lastAttemptTime = null;
          await _storeEncryptedCredentials(email, password, user);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
          );
        } else {
          _loginAttempts++;
          _lastAttemptTime = now;
          if (_loginAttempts >= 5) {
            setState(() => _isLocked = true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Too many attempts. Locked for 1 minute.')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid email or password')),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  void _navigateToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }
//function
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
      _passwordDisplay = _isPasswordVisible
          ? passwordController.text
          : '•' * passwordController.text.length;
    });
  }
///input
  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.blue, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
///Scaffold
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 50),
            Text(
              'Welcome Back!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Log in to your account',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // Email Field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: TextFormField(
                controller: emailController,
                decoration: _inputDecoration('Email'),
                validator: (value) {
                  value = _sanitizeInput(value);
                  if (value == null || value.isEmpty) {
                    return 'Enter Email';
                  }
                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                      .hasMatch(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[<>;{}]')),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Password Field with RawKeyboardListener and Eye Button
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ),
              child: RawKeyboardListener(
                focusNode: _passwordFocusNode,
                onKey: (RawKeyEvent event) {
                  if (event is RawKeyDownEvent) {
                    // Handle backspace
                    if (event.logicalKey == LogicalKeyboardKey.backspace) {
                      if (passwordController.text.isNotEmpty) {
                        setState(() {
                          passwordController.text = passwordController.text.substring(0, passwordController.text.length - 1);
                          _passwordDisplay = _isPasswordVisible
                              ? passwordController.text
                              : '•' * passwordController.text.length;
                        });
                      }
                      return;
                    }
                    // Handle printable characters
                    final character = event.character;
                    if (character != null && character.isNotEmpty && !event.isControlPressed && !event.isAltPressed && !event.isMetaPressed) {
                      setState(() {
                        passwordController.text += character;
                        _passwordDisplay = _isPasswordVisible
                            ? passwordController.text
                            : '•' * passwordController.text.length;
                      });
                    }
                  }
                },
                child: TextFormField(
                  controller: TextEditingController(text: _passwordDisplay),
                  decoration: _inputDecoration(
                    'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: _togglePasswordVisibility,
                      tooltip: _isPasswordVisible ? 'Hide password' : 'Show password',
                    ),
                  ),
                  readOnly: true, // Prevent direct typing
                  showCursor: true, // Show cursor for user feedback
                  validator: (value) {
                    final password = _sanitizeInput(passwordController.text);
                    if (password == null || password.isEmpty) {
                      return 'Enter Password';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.visiblePassword,
                  enableSuggestions: false,
                  autocorrect: false,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'[<>;{}]')),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLocked ? null : _login,
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: EdgeInsets.zero,
                ),
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: const Text(
                      'Login',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Sign Up Navigation
            TextButton(
              onPressed: _navigateToSignup,
              child: Text(
                "Don't have an account? Sign up",
                style: TextStyle(color: Colors.blue.shade700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }
}