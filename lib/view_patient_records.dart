import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPatientRecordsPage extends StatelessWidget {
  const ViewPatientRecordsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Patient Records")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('patients').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while waiting for data
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show error message if there's an error
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // Show message if no patient records found
              return const Center(child: Text("No patient records found."));
            } else {
              // Data exists, display it in a ListView
              final patientDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: patientDocs.length,
                itemBuilder: (context, index) {
                  final patientData = patientDocs[index].data() as Map<String, dynamic>;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(patientData['fullName'] ?? 'No Name'),
                      subtitle: Text(
                          'Phone: ${patientData['phone'] ?? 'N/A'}\n'
                          'Email: ${patientData['email'] ?? 'N/A'}\n'
                          'DOB: ${patientData['dob'] ?? 'N/A'}'),
                      onTap: () {
                        // You can add more detailed actions here if needed
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
