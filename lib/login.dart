import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_home.dart';
import 'receptionist.dart';
import 'doctor.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Check for admin credentials
    if (username == 'admin' && password == '123') {
      // Navigate to the admin home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminHomePage()),
      );
      return;
    }

    // Check for user credentials in SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedPassword = prefs.getString('user_$username'); // Use this key for password
    String? fullName = prefs.getString('fullName_$username'); // Retrieve full name for display
    String? role = prefs.getString('role_$username'); // Retrieve role

    if (storedPassword != null && role != null) {
      if (storedPassword == password) {
        // Navigate based on role
        if (role == 'Receptionist') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ReceptionistPage()),
          );
        } else if (role == 'Doctor') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DoctorPage()),
          );
        }
      } else {
        // Incorrect password
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Incorrect password')),
        );
      }
    } else {
      // User not found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
