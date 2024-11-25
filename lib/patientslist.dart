import 'package:flutter/material.dart';
import 'book_appointment.dart'; // Import BookAppointmentPage
import 'update_patient.dart'; // Import UpdatePatientPage

class PatientsListPage extends StatelessWidget {
  final List<Map<String, String>> patients;
  final Function(Map<String, String>) onPatientSelected;

  const PatientsListPage({
    super.key,
    required this.patients,
    required this.onPatientSelected,
  });

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
                  var patient = patients[index];
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(patient['Full Name'] ?? 'No Name'),
                      subtitle: Text('DOB: ${patient['Date of Birth']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Book Appointment button
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to BookAppointmentPage and pass patient details
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
                          
                          // Update Patient button
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to UpdatePatientPage and pass all patient data
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdatePatientPage(
                                    patientId: patient['ID'] ?? 'Unknown ID',
                                    patientName: patient['Full Name'] ?? 'Unknown Name',
                                    patientData: patient, // Pass the full patient data
                                  ),
                                ),
                              );
                            },
                            child: const Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(child: Text('No patients registered yet.')),
      ),
    );
  }
}
