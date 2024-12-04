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
  String? _selectedDoctor;
  List<String> _availableDoctors = [];
  Map<String, String> _patients = {}; // Mock data structure for patient search.

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  // Fetch available doctors from Firestore
  Future<void> _fetchDoctors() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance.collection('doctors').get();
      setState(() {
        _availableDoctors = querySnapshot.docs.map((doc) => doc.data()['name'] as String).toList();
      });
    } catch (e) {
      print("Error fetching doctors: $e");
    }
  }

  // Fetch patients (mock search implementation; replace with actual database logic)
  Future<void> _searchPatient(String query) async {
    try {
      // Replace this mock data with Firestore patient query logic
      final mockPatients = {
        'John Doe': '123456',
        'Jane Smith': '789012',
      };
      
      setState(() {
        _patients = Map.fromEntries(
          mockPatients.entries.where((entry) =>
            entry.key.toLowerCase().contains(query.toLowerCase())
          ),
        );
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

              // Select available doctor
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Select Doctor"),
                value: _selectedDoctor,
                items: _availableDoctors.map((doctor) {
                  return DropdownMenuItem(
                    value: doctor,
                    child: Text(doctor),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDoctor = value;
                  });
                },
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

  // Function to book an appointment
  Future<void> _bookAppointment() async {
    final patient = _patientSearchController.text;
    final date = _appointmentDateController.text;
    final doctor = _selectedDoctor;
    final reason = _reasonController.text;

    if (patient.isEmpty || date.isEmpty || doctor == null || reason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('appointments').add({
        'patient': patient,
        'doctor': doctor,
        'date': date,
        'reason': reason,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Appointment booked successfully!")),
      );

      // Clear fields after booking
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
    setState(() {
      _selectedDoctor = null;
    });
  }
}

extension AppointmentMapExtension<K, V> on Map<K, V> {
  /// Filters appointments based on a condition.
  Map<K, V> filter(bool Function(K key, V value) test) {
    final Map<K, V> filtered = {};
    forEach((key, value) {
      if (test(key, value)) {
        filtered[key] = value;
      }
    });
    return filtered;
  }
}
