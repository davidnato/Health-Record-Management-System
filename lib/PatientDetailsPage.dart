import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hrms/view_patient_records.dart';

class ViewPatientRecordsPage extends StatelessWidget {
  const ViewPatientRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Records"),
        backgroundColor: Colors.blueAccent, // Custom AppBar color
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('patients').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text("No patient records found."));
            } else {
              final patientDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: patientDocs.length,
                itemBuilder: (context, index) {
                  final patientData = patientDocs[index].data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 5, // Added shadow for card elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners for card
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0), // Padding inside the card
                      title: Text(
                        patientData['fullName'] ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone: ${patientData['phone'] ?? 'N/A'}'),
                          Text('Email: ${patientData['email'] ?? 'N/A'}'),
                          Text('DOB: ${patientData['dob'] ?? 'N/A'}'),
                        ],
                      ),
                      onTap: () {
                        // Navigate to PatientDetailsPage and pass all patient details
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientDetailsPage(
                              patientData: patientData,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
