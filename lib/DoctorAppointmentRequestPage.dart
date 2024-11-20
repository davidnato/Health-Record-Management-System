import 'package:flutter/material.dart';

class DoctorAppointmentRequestPage extends StatefulWidget {
  const DoctorAppointmentRequestPage({super.key});

  @override
  _DoctorAppointmentRequestPageState createState() =>
      _DoctorAppointmentRequestPageState();
}

class _DoctorAppointmentRequestPageState
    extends State<DoctorAppointmentRequestPage> {
  // Sample list of appointment requests for the doctor
  final List<Map<String, String>> _appointmentRequests = [
    {
      'patientName': 'John Doe',
      'appointmentDate': '2024-11-18',
      'reason': 'Check-up',
      'doctorName': 'Dr. Smith',
    },
    {
      'patientName': 'Jane Smith',
      'appointmentDate': '2024-11-19',
      'reason': 'Flu Symptoms',
      'doctorName': 'Dr. Smith',
    },
  ];

  // Method to accept the request
  void _acceptRequest(int index) {
    setState(() {
      // In a real app, here you would update the database or backend to confirm the appointment
      _appointmentRequests.removeAt(index); // Remove accepted request
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment request accepted')),
    );
  }

  // Method to decline the request
  void _declineRequest(int index) {
    setState(() {
      // In a real app, you would update the backend to decline the request
      _appointmentRequests.removeAt(index); // Remove declined request
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment request declined')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor\'s Appointment Requests'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _appointmentRequests.isNotEmpty
            ? ListView.builder(
                itemCount: _appointmentRequests.length,
                itemBuilder: (context, index) {
                  final request = _appointmentRequests[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(request['patientName'] ?? 'N/A'),
                      subtitle: Text(
                          'Date: ${request['appointmentDate'] ?? 'N/A'}\nReason: ${request['reason'] ?? 'N/A'}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.check),
                            onPressed: () => _acceptRequest(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.cancel),
                            onPressed: () => _declineRequest(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(child: Text('No pending requests.')),
      ),
    );
  }
}
