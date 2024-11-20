import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'update_patient.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<String> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _appointments = prefs.getStringList('appointments') ?? [];
    });
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
                                    patientName: 'Name Placeholder', // Replace with actual patient name if available
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
    );
  }
}
