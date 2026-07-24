import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> registerUser(
      String username, String email, String password) async {
    // Django Django signup endpoint URL (Apne backend view ke mutabik change kar sakte hain)
    const String url = 'http://localhost:8000/api/signup/';

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (!mounted) return;
        _showSnackBar(
            "Account Created Successfully! Please Login.", Colors.green);

        // Account banne ke baad automatic Login Screen par wapas bhejna
        Navigator.pop(context);
      } else {
        final errorData = jsonDecode(response.body);
        if (!mounted) return;
        _showSnackBar("Error: ${errorData['error'] ?? 'Signup failed'}",
            Colors.redAccent);
      }
    } catch (e) {
      _showSnackBar("Backend server se connect nahi ho paya!", Colors.orange);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.green),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.eco_rounded, size: 70, color: Colors.green),
                const SizedBox(height: 10),
                const Text(
                  "Create Account",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
                const Text(
                  "Join Eco-Scan and start earning points",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 30),

                // Username Field
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.mail_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 20),

                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
                const SizedBox(height: 30),

                // Register Button
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          String username = _usernameController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();

                          if (username.isEmpty ||
                              email.isEmpty ||
                              password.isEmpty) {
                            _showSnackBar(
                                "Please fill all fields", Colors.redAccent);
                          } else {
                            registerUser(username, email, password);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Sign Up",
                          style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
