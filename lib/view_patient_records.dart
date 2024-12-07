import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

class PatientDetailsPage extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientDetailsPage({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${patientData['fullName']} - Details"),
        backgroundColor: Colors.teal, // Set AppBar color
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Patient details card
            Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Name: ${patientData['fullName']}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Phone: ${patientData['phone'] ?? 'N/A'}'),
                    Text('Email: ${patientData['email'] ?? 'N/A'}'),
                    Text('DOB: ${patientData['dob'] ?? 'N/A'}'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Lab Results heading
            const Text('Lab Results:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            // Lab results stream
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('lab_results')
                    .where('patientName', isEqualTo: patientData['fullName'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error fetching lab results",
                          style: TextStyle(color: Colors.red)),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No lab results available"));
                  } else {
                    final labResults = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: labResults.length,
                      itemBuilder: (context, index) {
                        final labResult = labResults[index];
                        final testName = labResult['testName'];
                        final testResult = labResult['testResult'];
                        final testDate = (labResult['testDate'] as Timestamp).toDate();

                        // Format the date
                        final formattedDate = DateFormat('yyyy-MM-dd').format(testDate);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          child: ListTile(
                            title: Text("Test: $testName"),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Result: $testResult"),
                                Text("Date: $formattedDate"),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
