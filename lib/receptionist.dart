import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'patientslist.dart';
import 'book_appointment.dart';
import 'billing.dart';
import 'login.dart';

class ReceptionistPage extends StatefulWidget {
  const ReceptionistPage({super.key});

  @override
  _ReceptionistPageState createState() => _ReceptionistPageState();
}

class _ReceptionistPageState extends State<ReceptionistPage> {
  final List<Map<String, String>> _patients = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadPatientsFromSharedPreferences(); // Load patients when the app starts
  }

  // Save patient to SharedPreferences
  Future<void> _addPatient(Map<String, String> patient) async {
    final prefs = await SharedPreferences.getInstance();
    final String uniqueId = DateTime.now().millisecondsSinceEpoch.toString();
    patient['id'] = uniqueId; // Add unique ID
    setState(() {
      _patients.add(patient); // Add to local list
    });

    // Save the updated patient list to SharedPreferences
    List<String> patientsJson =
        _patients.map((patient) => jsonEncode(patient)).toList();
    await prefs.setStringList('patients', patientsJson);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Patient added successfully')),
    );
  }

  // Load patients from SharedPreferences
  Future<void> _loadPatientsFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? patientsJson = prefs.getStringList('patients');
    if (patientsJson != null) {
      setState(() {
        _patients.clear();
        _patients.addAll(
          patientsJson.map((jsonString) => Map<String, String>.from(jsonDecode(jsonString))),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      PatientRegistrationPage(onPatientRegistered: _addPatient),
      PatientsListPage(
        patients: _patients,
        onPatientSelected: (patient) {
          print('Patient selected: ${patient['full_name']}');
        },
      ),
      const BookAppointmentPage(patient: {}),
      const BillingPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptionist Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Notifications'),
                  content: const Text('You have new notifications.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.person_add),
                label: Text('Register New Patient'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.list),
                label: Text('View Patients List'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.calendar_today),
                label: Text('Book Appointment'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.attach_money),
                label: Text('Bill Patient'),
              ),
            ],
          ),
          Expanded(
            child: pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}

class PatientRegistrationPage extends StatefulWidget {
  final Function(Map<String, String>) onPatientRegistered;

  const PatientRegistrationPage({required this.onPatientRegistered, super.key});

  @override
  _PatientRegistrationPageState createState() => _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, String> _patientData = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Personal Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) => value!.isEmpty ? 'Please enter full name' : null,
                onSaved: (value) => _patientData['full_name'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date of Birth'),
                validator: (value) => value!.isEmpty ? 'Please enter date of birth' : null,
                onSaved: (value) => _patientData['date_of_birth'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Gender'),
                validator: (value) => value!.isEmpty ? 'Please enter gender' : null,
                onSaved: (value) => _patientData['gender'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Please enter phone number' : null,
                onSaved: (value) => _patientData['phone_number'] = value!,
              ),
              const SizedBox(height: 16),
              const Text('Identification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'National ID or Passport'),
                validator: (value) => value!.isEmpty ? 'Please enter ID or Passport number' : null,
                onSaved: (value) => _patientData['national_id_or_passport'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Insurance Provider'),
                validator: (value) => value!.isEmpty ? 'Please enter insurance provider' : null,
                onSaved: (value) => _patientData['insurance_provider'] = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Policy Number'),
                validator: (value) => value!.isEmpty ? 'Please enter policy number' : null,
                onSaved: (value) => _patientData['policy_number'] = value!,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onPatientRegistered(_patientData);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Patient Registered Successfully')),
                    );
                  }
                },
                child: const Text('Register Patient'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
