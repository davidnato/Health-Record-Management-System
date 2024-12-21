import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsPage extends StatelessWidget {
  final Map<String, dynamic> patientData;

  const PatientDetailsPage({super.key, required this.patientData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patientData['fullName'] ?? 'Patient Details'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Info Section
              _buildSectionTitle('Patient Information'),
              _buildCard([
                _buildDetailRow('Full Name', patientData['fullName']),
                _buildDetailRow('Phone', patientData['phone']),
                _buildDetailRow('Email', patientData['email']),
                _buildDetailRow('DOB', _formatDate(patientData['dob'])),
                _buildDetailRow('Gender', patientData['gender']),
                _buildDetailRow('Address', patientData['address']),
              ]),

              // Emergency Contact Section
              _buildSectionTitle('Emergency Contact'),
              _buildCard([
                _buildDetailRow('Name', patientData['emergencyContactName']),
                _buildDetailRow('Phone', patientData['emergencyContactPhone']),
              ]),

              // Insurance Information Section
              _buildSectionTitle('Insurance Information'),
              _buildCard([
                _buildDetailRow('Company', patientData['insuranceCompany']),
                _buildDetailRow('Policy Number', patientData['insurancePolicy']),
              ]),

              // Medical History Section
              _buildSectionTitle('Medical History'),
              _buildCard([
                Text(
                  patientData['medicalHistory'] ?? 'No medical history available',
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ]),

              // Vitals Section
              _buildSectionTitle('Vitals'),
              _buildCard([
                _buildDetailRow('Heart Rate', patientData['heartRate']),
                _buildDetailRow('Height', patientData['height']),
                _buildDetailRow('Weight', patientData['weight']),
                _buildDetailRow('Oxygen Saturation', '${patientData['oxygenSaturation']} %'),
                _buildDetailRow('Respiratory Rate', '${patientData['respiratoryRate']} breaths/min'),
                _buildDetailRow('Body Temperature', '${patientData['bodyTemperature']} °C'),
                _buildDetailRow('Blood Pressure', patientData['bloodPressure']),
                _buildDetailRow('Allergies', patientData['allergies']),
              ]),

              // Appointments Section
              _buildSectionTitle('Appointments'),
              _buildAppointmentsSection(),

              // Lab Results Section
              _buildSectionTitle('Lab Results'),
              _buildLabResultsSection(),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    if (timestamp is Timestamp) {
      DateTime dateTime = timestamp.toDate();
      return '${dateTime.toLocal()}'; // Format as string (adjust format if needed)
    }
    return timestamp ?? 'N/A';
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Text(
            value ?? 'N/A',
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('patientId', isEqualTo: patientData['id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("No appointments found.", style: TextStyle(fontSize: 16)),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data!.docs.map((doc) {
              final appointment = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  '• ${_formatDate(appointment['date'])} - ${appointment['details'] ?? 'No Details'}',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildLabResultsSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('lab_results')
          .where('patientId', isEqualTo: patientData['id'])
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Text("No lab results found.", style: TextStyle(fontSize: 16)),
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: snapshot.data!.docs.map((doc) {
              final labResult = doc.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Text(
                  '• ${labResult['testName'] ?? 'Unknown Test'}: ${labResult['testResult'] ?? 'No Result'}',
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}
