import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'update_patient.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<String> _appointments = [];
  List<String> _doctors = [];
  String? _selectedDoctor;

  @override
  void initState() {
    super.initState();
    _loadAppointments();
    _loadDoctors();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _appointments = prefs.getStringList('appointments') ?? [];
    });
  }

  Future<void> _loadDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? usersJson = prefs.getStringList('users');

    if (usersJson != null) {
      final doctors = usersJson
          .map((user) => jsonDecode(user) as Map<String, dynamic>)
          .where((user) => user['role'] == 'Doctor') // Filter for doctors
          .map((doctor) => doctor['full_name'] as String)
          .toList();
      setState(() {
        _doctors = doctors;
        if (_doctors.isNotEmpty) {
          _selectedDoctor = _doctors.first; // Default to the first doctor
        }
      });
    }
  }

  Future<void> _addAppointment(String patientId, String date) async {
    if (_selectedDoctor == null) return;

    final prefs = await SharedPreferences.getInstance();
    final appointment = '$patientId|$date|$_selectedDoctor';
    setState(() {
      _appointments.add(appointment);
    });
    await prefs.setStringList('appointments', _appointments);
  }

  Future<void> _removeAppointment(int index) async {
    final prefs = await SharedPreferences.getInstance();
    _appointments.removeAt(index);
    await prefs.setStringList('appointments', _appointments);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_doctors.isEmpty)
              const Text('No doctors available. Please add doctors first.')
            else
              DropdownButton<String>(
                value: _selectedDoctor,
                onChanged: (value) {
                  setState(() {
                    _selectedDoctor = value;
                  });
                },
                items: _doctors
                    .map((doctor) => DropdownMenuItem(
                          value: doctor,
                          child: Text(doctor),
                        ))
                    .toList(),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: _appointments.isNotEmpty
                  ? ListView.builder(
                      itemCount: _appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = _appointments[index].split('|');
                        final patientId = appointment[0];
                        final date = appointment[1];
                        final doctor = appointment[2];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text('Patient: $patientId'),
                            subtitle: Text('Date: $date, Doctor: $doctor'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => UpdatePatientPage(
                                          patientId: patientId,
                                          patientName: 'Name Placeholder',
                                          patientData: const {}, // Replace with actual patient name if available
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    _removeAppointment(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No appointments booked yet.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
