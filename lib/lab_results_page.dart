import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class LabResultsPage extends StatelessWidget {
  const LabResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lab Results"),
        backgroundColor: Colors.blueAccent, // Adjusting the AppBar color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('lab_results').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error fetching lab results"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No lab results available"));
          }

          final labResults = snapshot.data!.docs;

          return ListView.builder(
            itemCount: labResults.length,
            itemBuilder: (context, index) {
              final labResult = labResults[index];
              final patientName = labResult['patientName'];
              final testName = labResult['testName'];
              final testResult = labResult['testResult'];
              final testDate = (labResult['testDate'] as Timestamp).toDate();

              final formattedDate = DateFormat('yyyy-MM-dd').format(testDate);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                elevation: 5, // Adding elevation for shadow effect
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // Rounded corners
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16), // Add padding for better spacing
                  title: Text(
                    "Test: $testName",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Text(
                        "Patient: $patientName",
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      Text(
                        "Result: $testResult",
                        style: const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      Text(
                        "Date: $formattedDate",
                        style: const TextStyle(fontSize: 14, color: Colors.black38),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
