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
      appBar: AppBar(title: const Text("Receptionist Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PatientManagementPage()),
                );
              },
              child: const Text("Patient Management"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppointmentPage()),
                );
              },
              child: const Text("Appointment Management"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BillingPage()),
                );
              },
              child: const Text("Billing Management"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Red button for logout
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const AuthScreen()),
                  (route) => false, // Remove all previous routes
                );
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
