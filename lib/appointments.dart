import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  final appointment = _appointments[index].split('|'); // Split the string into parts
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Patient: ${appointment[0]}'),
                      subtitle: Text(
                        'Date: ${appointment[1]}, Doctor: ${appointment[2]}',
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
