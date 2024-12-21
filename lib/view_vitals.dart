import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPatientVitalsPage extends StatelessWidget {
  final String patientId;

  const ViewPatientVitalsPage({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Vitals'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('patients')
              .doc('fOjMifCYKIEvnjRLA9Cx')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text('No patient data available.'));
            } else {
              var vitalsData = snapshot.data!.data() as Map<String, dynamic>;

              // Debugging: print the data to verify
              print('Vitals Data: $vitalsData');

              return ListView(
                children: [
                  ListTile(
                    title: const Text('Full Name'),
                    subtitle: Text(vitalsData['fullName']?.toString() ?? 'Not Available'),
                  ),
                  ListTile(
                    title: const Text('Body Temperature'),
                    subtitle: Text('${vitalsData['bodyTemperature']?.toString() ?? 'Not Available'} °C'),
                  ),
                  ListTile(
                    title: const Text('Heart Rate'),
                    subtitle: Text('${vitalsData['heartRate']?.toString() ?? 'Not Available'} bpm'),
                  ),
                  ListTile(
                    title: const Text('Blood Pressure'),
                    subtitle: Text(vitalsData['bloodPressure']?.toString() ?? 'Not Available'),
                  ),
                  ListTile(
                    title: const Text('Respiratory Rate'),
                    subtitle: Text('${vitalsData['respiratoryRate']?.toString() ?? 'Not Available'} breaths/min'),
                  ),
                  ListTile(
                    title: const Text('Oxygen Saturation'),
                    subtitle: Text('${vitalsData['oxygenSaturation']?.toString() ?? 'Not Available'} %'),
                  ),
                  ListTile(
                    title: const Text('Weight'),
                    subtitle: Text('${vitalsData['weight']?.toString() ?? 'Not Available'} kg'),
                  ),
                  ListTile(
                    title: const Text('Height'),
                    subtitle: Text('${vitalsData['height']?.toString() ?? 'Not Available'} cm'),
                  ),
                  ListTile(
                    title: const Text('Allergies'),
                    subtitle: Text(vitalsData['allergies']?.toString() ?? 'Not Available'),
                  ),
                  ListTile(
                    title: const Text('Past Medical History'),
                    subtitle: Text(vitalsData['pastMedicalHistory']?.toString() ?? 'Not Available'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
