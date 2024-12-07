import 'package:flutter/material.dart';
import 'package:hrms/AppointmentPage.dart';
import 'package:hrms/BillingPage.dart';
import 'package:hrms/patient_management.dart'; // Patient management page
import 'package:hrms/auth_screen.dart'; // Authentication screen

class ReceptionistPage extends StatelessWidget {
  const ReceptionistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receptionist Dashboard"),
        backgroundColor: Colors.teal, // A modern teal color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title Section
            const Text(
              "Welcome, Receptionist",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Manage patient appointments, billing, and more.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),

            // Action Buttons Section
            _buildActionButton(
              context,
              label: "Patient Management",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PatientManagementPage()),
                );
              },
              color: Colors.teal,
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              label: "Appointment Management",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppointmentPage()),
                );
              },
              color: Colors.orange,
            ),
            const SizedBox(height: 20),
            _buildActionButton(
              context,
              label: "Billing Management",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BillingPage()),
                );
              },
              color: Colors.blue,
            ),
            const SizedBox(height: 40),

            // Logout Button
            _buildActionButton(
              context,
              label: "Logout",
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false, // Remove all previous routes
                );
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create styled buttons
  Widget _buildActionButton(BuildContext context, {required String label, required VoidCallback onPressed, required Color color}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 5, // Adding a slight shadow effect
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
