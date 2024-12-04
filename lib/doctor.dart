import 'package:flutter/material.dart';
import 'package:hrms/appointments_page.dart';
import 'package:hrms/prescriptions_page.dart';
import 'package:hrms/lab_results_page.dart';
import 'package:hrms/auth_screen.dart';
import 'package:hrms/view_patient_records.dart'; // For logout redirection

class DoctorPage extends StatelessWidget {
  const DoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctor Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AppointmentsPage()),
                );
              },
              child: const Text("View Appointments"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewPatientRecordsPage()),
              );
              },
              child: const Text("View Patients"),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PrescriptionsPage()),
                );
              },
              child: const Text("Manage Prescriptions"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LabResultsPage()),
                );
              },
              child: const Text("Review Lab Results"),
            ),
          ],
        ),
      ),
    );
  }
}
