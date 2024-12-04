import 'package:flutter/material.dart';
import 'package:hrms/register_patient.dart';
import 'package:hrms/update_patient.dart';
import 'package:hrms/view_patient_records.dart';

class PatientManagementPage extends StatelessWidget {
  const PatientManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Management")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Register Patient"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPatientPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Update Patient Information"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdatePatientPage()),
              );
            },
          ),
          ListTile(
            title: const Text("View Patient Records"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ViewPatientRecordsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
