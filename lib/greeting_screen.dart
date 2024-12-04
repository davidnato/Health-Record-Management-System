import 'package:flutter/material.dart';

class GreetingScreen extends StatelessWidget {
  final String role;

  const GreetingScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome"),
      ),
      body: Center(
        child: Text(
          "Hello, $role!",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
