import 'package:flutter/material.dart';
import 'book_appointment.dart';
import 'update_patient.dart';
import 'patient_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PatientsListPage extends StatefulWidget {
  final List<Map<String, String>> patients;
  final Function(dynamic patient) onPatientSelected; // Callback for selected patient

  const PatientsListPage({
    Key? key,
    required this.patients,
    required this.onPatientSelected,
  }) : super(key: key);

  @override
  _PatientsListPageState createState() => _PatientsListPageState();
}

class _PatientsListPageState extends State<PatientsListPage> {
  List<Map<String, String>> patients = [];

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  /// Load patients from SharedPreferences
  Future<void> _loadPatients() async {
    final prefs = await SharedPreferences.getInstance();
    final patientsJsonList = prefs.getStringList('patients') ?? [];

    setState(() {
      patients = patientsJsonList
          .map((jsonString) => Map<String, String>.from(jsonDecode(jsonString)))
          .toList();
    });
  }

  /// Delete a patient from SharedPreferences and update UI
  Future<void> _deletePatient(String patientId) async {
    final prefs = await SharedPreferences.getInstance();
    final patientsJsonList = prefs.getStringList('patients') ?? [];

    // Remove the patient with the specified ID
    patientsJsonList.removeWhere((jsonString) {
      final patient = jsonDecode(jsonString) as Map<String, dynamic>;
      return patient['ID'] == patientId;
    });

    await prefs.setStringList('patients', patientsJsonList);

    setState(() {
      patients.removeWhere((patient) => patient['ID'] == patientId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient deleted successfully')),
    );
  }

  /// Build the patient list
  Widget _buildPatientCard(Map<String, String> patient) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          // Pass the selected patient to the callback
          widget.onPatientSelected(patient);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailsPage(
                patientId: patient['ID'] ?? 'Unknown ID',
              ),
            ),
          );
        },
        child: ListTile(
          title: Text(patient['Full Name'] ?? 'No Name'),
          subtitle: Text('DOB: ${patient['Date of Birth']}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to BookAppointmentPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookAppointmentPage(
                        patient: {
                          'ID': patient['ID'] ?? '',
                          'Full Name': patient['Full Name'] ?? '',
                        },
                      ),
                    ),
                  );
                },
                child: const Text('Book Appointment'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Navigate to UpdatePatientPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdatePatientPage(
                        patientId: patient['ID'] ?? 'Unknown ID',
                        patientName: patient['Full Name'] ?? 'Unknown Name',
                        patientData: patient,
                      ),
                    ),
                  );
                },
                child: const Text('Update'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  // Delete the patient
                  _deletePatient(patient['ID'] ?? 'Unknown ID');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patients List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: patients.isNotEmpty
            ? ListView.builder(
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  return _buildPatientCard(patient);
                },
              )
            : const Center(child: Text('No patients registered yet.')),
      ),
    );
  }
}
