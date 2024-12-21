import 'package:flutter/material.dart';
import 'package:hrms/PatientDetailsPage.dart';
import 'package:hrms/patient_details_cluster.dart';
import 'package:hrms/register_patient.dart';
import 'package:hrms/update_patient.dart';
import 'package:hrms/view_patient_records.dart';

class PatientManagementPage extends StatelessWidget {
  const PatientManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Management"),
        backgroundColor: Colors.blueAccent, // Custom AppBar color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildListTile(
              context,
              title: "Register Patient",
              icon: Icons.person_add,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterPatientPage()),
                );
              },
            ),
            _buildListTile(
              context,
              title: "Update Patient Information",
              icon: Icons.update,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UpdatePatientPage()),
                );
              },
            ),
            _buildListTile(
              context,
              title: "View Patient Records",
              icon: Icons.visibility,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ViewPatientRecordsPage(patientId: null,)),
                );
              },
            ),
            _buildListTile(
              context,
              title: "View Patient Records",
              icon: Icons.visibility,
              onTap: () {
                Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PatientSummaryPage(patientId: 'somePatientId'),
                ),
              );

              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(BuildContext context, {required String title, required IconData icon, required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for a modern look
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        leading: Icon(icon, color: Colors.blueAccent), // Icon styling
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600), // Title styling
        ),
        onTap: onTap,
      ),
    );
  }
}
