import 'package:flutter/material.dart';

class UpdatePatientPage extends StatelessWidget {
  const UpdatePatientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Patient Details'),
      ),
      body: const Center(
        child: Text('Update Patient Details form will be displayed here.'),
      ),
    );
  }
}
