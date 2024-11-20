import 'package:flutter/material.dart';

class SendAppointmentRequestPage extends StatefulWidget {
  const SendAppointmentRequestPage({super.key});

  @override
  _SendAppointmentRequestPageState createState() =>
      _SendAppointmentRequestPageState();
}

class _SendAppointmentRequestPageState extends State<SendAppointmentRequestPage> {
  final _formKey = GlobalKey<FormState>();
  final _patientData = {
    'patientName': '',
    'appointmentDate': '',
    'reason': '',
    'doctorName': '',
  };

  // Simulating sending a request (notification to the doctor)
  void _sendRequestToDoctor() {
    // In a real application, this would send the request to the doctor, e.g., through an API
    // Here we just show a success message for simulation

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Appointment request sent to the doctor')),
    );

    // You can store this request in a local storage or database for the doctor to retrieve
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Appointment Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the patient\'s name' : null,
                onSaved: (value) => _patientData['patientName'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Appointment Date'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the appointment date' : null,
                onSaved: (value) => _patientData['appointmentDate'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Reason for Visit'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the reason for the visit' : null,
                onSaved: (value) => _patientData['reason'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Doctor Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter the doctor\'s name' : null,
                onSaved: (value) => _patientData['doctorName'] = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _sendRequestToDoctor();
                  }
                },
                child: const Text('Send Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
