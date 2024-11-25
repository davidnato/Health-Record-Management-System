import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUserPage extends StatefulWidget {
  const AddUserPage({super.key});

  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  String _selectedRole = 'Receptionist'; // Default role

  // Method to save user data to SharedPreferences
  Future<void> _addUser() async {
    final prefs = await SharedPreferences.getInstance();

    // Saving user details as key-value pairs
    await prefs.setString('username', _usernameController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setString('full_name', _fullNameController.text);
    await prefs.setString('role', _selectedRole);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User added successfully')),
    );

    // Clear the text fields
    _usernameController.clear();
    _passwordController.clear();
    _fullNameController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _fullNameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            const SizedBox(height: 20),
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
            DropdownButton<String>(
              value: _selectedRole,
              items: const [
                DropdownMenuItem(value: 'Receptionist', child: Text('Receptionist')),
                DropdownMenuItem(value: 'Doctor', child: Text('Doctor')),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addUser,
              child: const Text('Add User'),
            ),
          ],
        ),
      ),
    );
  }
}
