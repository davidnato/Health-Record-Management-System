import 'package:flutter/material.dart';

class DeleteUserPage extends StatelessWidget {
  const DeleteUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delete User")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Enter User ID or Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Delete user logic here
              },
              child: const Text("Delete User"),
            ),
          ],
        ),
      ),
    );
  }
}
