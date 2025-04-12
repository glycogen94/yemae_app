import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;

  // Input validation function
  bool _validateInput() {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both email and password.';
        _isLoading = false; // Ensure loading indicator is off
      });
      return false;
    }
    // Optional: Add more specific validation like email format check if needed
    final emailRegex = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(_emailController.text.trim())) {
      setState(() {
        _errorMessage = 'Please enter a valid email address.';
        _isLoading = false;
      });
      return false;
    }
    return true;
  }

  Future<void> _login() async {
    // Reset error message and start loading
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Validate input first
    if (!_validateInput()) {
      // If validation fails, _validateInput already sets the error message and stops loading
      return;
    }

    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation happens via AuthWrapper
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage =
            e.message ??
            'An unknown error occurred.'; // Provide default message
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _signUp() async {
    // Reset error message and start loading
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Validate input first
    if (!_validateInput()) {
      // If validation fails, _validateInput already sets the error message and stops loading
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      // Navigation happens via AuthWrapper
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage =
            e.message ??
            'An unknown error occurred.'; // Provide default message
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login / Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // Display error message if it exists
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                ), // Add some space below the error
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(onPressed: _login, child: const Text('Login')),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('Sign Up'),
                  ),
                ],
              ),
            // Moved the error message display above the buttons for better visibility before action
          ],
        ),
      ),
    );
  }
}
