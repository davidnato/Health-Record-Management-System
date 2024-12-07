import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart'; // Home page after login
import 'auth_service.dart'; // Auth service for login
import 'receptionist.dart'; // Receptionist page
import 'doctor.dart'; // Doctor page

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  final AuthService _authService = AuthService();

  void _authenticate() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showError("Please fill in all fields.");
      return;
    }

    try {
      User? user;
      String role = '';
      if (_isLogin) {
        user = await _authService.login(email, password);
        if (user != null) {
          role = await _authService.getUserRole();
        }
      } else {
        user = await _authService.register(email, password);
        role = 'Receptionist'; // Default role after registration
      }

      if (user != null) {
        _showSuccess("Logged in successfully!");

        // Navigate based on the user's role
        if (role == 'receptionist') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReceptionistPage()),
          );
        } else if (role == 'doctor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DoctorPage()),
          );
        } else if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const AdminPage()),
          );
        } else {
          _showError("Role not assigned");
        }
      }
    } catch (e) {
      _showError("Error: $e");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.red,
    ));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: Colors.green,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side (Blue color)
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue, // Blue color on the left side
            ),
          ),
          // Right side (Login form)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: "Email",
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,  // Correct way to use obscureText
                    decoration: const InputDecoration(
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(_isLogin ? "Login" : "Register"),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? "Don't have an account? Register"
                          : "Already have an account? Login",
                      style: const TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
