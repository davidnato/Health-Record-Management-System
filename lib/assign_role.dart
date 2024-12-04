import 'package:flutter/material.dart';

class AssignRolePage extends StatelessWidget {
  const AssignRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assign Role")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const TextField(
              decoration: InputDecoration(labelText: "Enter User ID or Email"),
            ),
            DropdownButton<String>(
              hint: const Text("Select Role"),
              items: <String>['Admin', 'Doctor', 'Nurse', 'Receptionist']
                  .map((String role) {
                return DropdownMenuItem<String>(
                  value: role,
                  child: Text(role),
                );
              }).toList(),
              onChanged: (value) {
                // Assign role logic here
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Role assignment logic here
              },
              child: const Text("Assign Role"),
            ),
          ],
        ),
      ),
    );
  }
}
