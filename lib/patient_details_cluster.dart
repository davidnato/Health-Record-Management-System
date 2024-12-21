import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientSummaryPage extends StatelessWidget {
  final String patientId;

  const PatientSummaryPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Summary"),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('patients').doc(patientId).get(),
        builder: (context, patientSnapshot) {
          if (patientSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!patientSnapshot.hasData || patientSnapshot.data == null) {
            return const Center(child: Text("Patient not found"));
          }

          final patientData = patientSnapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Basic Details
                Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name: ${patientData['fullName']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text("Phone: ${patientData['phone']}"),
                        Text("Email: ${patientData['email']}"),
                        Text("DOB: ${patientData['dob']}"),
                        Text("Address: ${patientData['address']}"),
                      ],
                    ),
                  ),
                ),

                // Appointments
                const SizedBox(height: 20),
                const Text("Appointments", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('appointments').where('patientId', isEqualTo: patientId).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final appointments = snapshot.data?.docs ?? [];
                    if (appointments.isEmpty) {
                      return const Text("No appointments available.");
                    }
                    return Column(
                      children: appointments.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['date'] ?? 'Unknown Date'),
                          subtitle: Text(data['reason'] ?? 'No Reason'),
                        );
                      }).toList(),
                    );
                  },
                ),

                // Billing
                const SizedBox(height: 20),
                const Text("Billing", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection('billing').where('patientId', isEqualTo: patientId).get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final bills = snapshot.data?.docs ?? [];
                    if (bills.isEmpty) {
                      return const Text("No billing information available.");
                    }
                    return Column(
                      children: bills.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['itemizedCharges'] ?? 'Unknown Item'),
                          trailing: Text("\$${data['total'] ?? '0'}"),
                        );
                      }).toList(),
                    );
                  },
                ),

                // Diagnoses
                const SizedBox(height: 20),
                const Text("Diagnoses", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('diagnoses').where('userId', isEqualTo: patientId).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final diagnoses = snapshot.data?.docs ?? [];
                    if (diagnoses.isEmpty) {
                      return const Text("No diagnoses available.");
                    }
                    return Column(
                      children: diagnoses.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text("Symptoms: ${data['symptoms']}"),
                          subtitle: Text("Diagnosis: ${data['diagnosis']}"),
                        );
                      }).toList(),
                    );
                  },
                ),

                // Lab Results
                const SizedBox(height: 20),
                const Text("Lab Results", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('lab_results').where('patientId', isEqualTo: patientId).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    final labResults = snapshot.data?.docs ?? [];
                    if (labResults.isEmpty) {
                      return const Text("No lab results available.");
                    }
                    return Column(
                      children: labResults.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text(data['testName'] ?? 'Unknown Test'),
                          subtitle: Text("Result: ${data['testResult']}"),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
