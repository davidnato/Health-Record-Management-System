import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'update_patient.dart';

class PatientDetailsPage extends StatefulWidget {
  final String patientId;

  const PatientDetailsPage({super.key, required this.patientId});

  @override
  _PatientDetailsPageState createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  Map<String, String>? patientDetails;

  @override
  void initState() {
    super.initState();
    _loadPatientDetails();
  }

  // Fetch the patient details from SharedPreferences using the patient ID
  Future<void> _loadPatientDetails() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> patientsJsonList = prefs.getStringList('patients') ?? [];

    for (var patientJson in patientsJsonList) {
      Map<String, dynamic> patient = jsonDecode(patientJson); // This gives Map<String, dynamic>
      if (patient['ID'] == widget.patientId) {
        setState(() {
          // Convert the dynamic map to Map<String, String> manually
          patientDetails = {
            'ID': patient['ID'] ?? 'No ID',
            'Full Name': patient['Full Name'] ?? 'No Name',
            'Date of Birth': patient['Date of Birth'] ?? 'No DOB',
            'Address': patient['Address'] ?? 'Not provided',
            'Phone': patient['Phone'] ?? 'Not provided',
            'Email': patient['Email'] ?? 'Not provided',
            'Previous Illnesses': patient['Previous Illnesses'] ?? 'Not provided',
            'Weight': patient['Weight'] ?? 'Not provided',
            'Pressure': patient['Pressure'] ?? 'Not provided',
            'Temperature': patient['Temperature'] ?? 'Not provided',
          };
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (patientDetails == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Patient Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient ID: ${patientDetails!['ID']}'),
            const SizedBox(height: 10),
            Text('Full Name: ${patientDetails!['Full Name']}'),
            const SizedBox(height: 10),
            Text('Date of Birth: ${patientDetails!['Date of Birth']}'),
            const SizedBox(height: 10),
            Text('Address: ${patientDetails!['Address']}'),
            const SizedBox(height: 10),
            Text('Phone: ${patientDetails!['Phone']}'),
            const SizedBox(height: 10),
            Text('Email: ${patientDetails!['Email']}'),
            const SizedBox(height: 20),
            // New Fields for Additional Patient Data
            Text('Previous Illnesses: ${patientDetails!['Previous Illnesses']}'),
            const SizedBox(height: 10),
            Text('Weight: ${patientDetails!['Weight']}'),
            const SizedBox(height: 10),
            Text('Pressure: ${patientDetails!['Pressure']}'),
            const SizedBox(height: 10),
            Text('Temperature: ${patientDetails!['Temperature']}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the update page with the current patient data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePatientPage(
                      patientId: widget.patientId,
                      patientName: patientDetails!['Full Name']!,
                      patientData: {
                        'Previous Illnesses': patientDetails!['Previous Illnesses']!,
                        'Weight': patientDetails!['Weight']!,
                        'Pressure': patientDetails!['Pressure']!,
                        'Temperature': patientDetails!['Temperature']!,
                      },
                    ),
                  ),
                );
              },
              child: const Text('Edit Patient Details'),
            ),
          ],
        ),
      ),
    );
  }
}
