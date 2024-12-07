import 'package:flutter/material.dart';

class AppointmentsPage extends StatelessWidget {
  // Declare required parameters to be passed in
  final String patientName;
  final String appointmentDate;
  final String doctorName;
  final String reason;

  // Constructor for receiving the arguments
  const AppointmentsPage({
    super.key,
    required this.patientName,
    required this.appointmentDate,
    required this.doctorName,
    required this.reason,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointment Details")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Patient Name
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: const Text("Patient Name", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(patientName, style: const TextStyle(fontSize: 18)),
                ),
              ),

              // Appointment Date
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: const Text("Appointment Date", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(appointmentDate, style: const TextStyle(fontSize: 18)),
                ),
              ),

              // Doctor Name
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: const Text("Doctor", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(doctorName, style: const TextStyle(fontSize: 18)),
                ),
              ),

              // Reason for Visit
              Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: const Text("Reason for Visit", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(reason, style: const TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
