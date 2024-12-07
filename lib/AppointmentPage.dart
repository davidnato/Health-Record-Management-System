import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  final _patientSearchController = TextEditingController();
  final _appointmentDateController = TextEditingController();
  final _reasonController = TextEditingController();
  final _doctorNameController = TextEditingController();
  Map<String, String> _patients = {}; // Patient search results

  // Search patients in Firestore
  Future<void> _searchPatient(String query) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('patients')
          .where('fullName', isGreaterThanOrEqualTo: query)
          .where('fullName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      setState(() {
        _patients = {
          for (var doc in querySnapshot.docs)
            doc['fullName']: doc.id
        };
      });
    } catch (e) {
      print("Error searching patients: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Appointments")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search for patient
              TextField(
                controller: _patientSearchController,
                decoration: InputDecoration(
                  labelText: "Search Patient",
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _searchPatient(_patientSearchController.text);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Display search results
              _patients.isNotEmpty
                  ? ListView(
                      shrinkWrap: true,
                      children: _patients.keys.map((name) {
                        return ListTile(
                          title: Text(name),
                          subtitle: Text("ID: ${_patients[name]}"),
                          onTap: () {
                            setState(() {
                              _patientSearchController.text = name;
                              _patients.clear();
                            });
                          },
                        );
                      }).toList(),
                    )
                  : Container(),

              const SizedBox(height: 20),

              // Doctor name input
              TextField(
                controller: _doctorNameController,
                decoration: const InputDecoration(labelText: "Doctor Name"),
              ),

              const SizedBox(height: 20),

              // Appointment details
              TextField(
                controller: _appointmentDateController,
                decoration: const InputDecoration(
                  labelText: "Appointment Date & Time",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      setState(() {
                        _appointmentDateController.text =
                            "${pickedDate.toLocal()} ${time.format(context)}";
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 20),

              // Reason for visit
              TextField(
                controller: _reasonController,
                decoration: const InputDecoration(labelText: "Reason for Visit"),
              ),

              const SizedBox(height: 20),

              // Submit button
              ElevatedButton(
                onPressed: _bookAppointment,
                child: const Text("Book Appointment"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Book an appointment
  Future<void> _bookAppointment() async {
    final patient = _patientSearchController.text;
    final date = _appointmentDateController.text;
    final doctor = _doctorNameController.text;
    final reason = _reasonController.text;

    if (patient.isEmpty || date.isEmpty || doctor.isEmpty || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      // Save appointment data to Firestore
      final docRef = await FirebaseFirestore.instance.collection('appointments').add({
        'patient': patient,
        'doctor': doctor,
        'date': date,
        'reason': reason,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment booked successfully!")),
      );

      // Clear form fields
      _clearForm();
    } catch (e) {
      print("Error booking appointment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to book appointment")),
      );
    }
  }

  // Clear form fields
  void _clearForm() {
    _patientSearchController.clear();
    _appointmentDateController.clear();
    _reasonController.clear();
    _doctorNameController.clear();
  }
}
