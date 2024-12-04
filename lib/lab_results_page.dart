import 'package:flutter/material.dart';

class LabResultsPage extends StatelessWidget {
  const LabResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lab Results")),
      body: const Center(
        child: Text("Lab Results Page: Review Diagnostic Reports Here."),
      ),
    );
  }
}
