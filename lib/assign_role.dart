import 'package:flutter/material.dart';

class AssignRolePage extends StatelessWidget {
  const AssignRolePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assign Role")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User ID or Email Input
              const TextField(
                decoration: InputDecoration(
                  labelText: "Enter User ID or Email",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 20),

              // Role Selection Dropdown
              DropdownButtonFormField<String>(
                hint: const Text("Select Role"),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                items: <String>['Admin', 'Doctor', 'Nurse', 'Receptionist']
                    .map((String role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (value) {
                  // Handle role selection
                },
              ),
              const SizedBox(height: 20),

              // Assign Role Button
              ElevatedButton(
                onPressed: () {
                  // Role assignment logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Role assigned successfully!")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Assign Role"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
