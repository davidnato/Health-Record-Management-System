import 'package:flutter/material.dart';
import 'lab_results_storage.dart'; // Import the storage class

class LabResultsPage extends StatefulWidget {
  const LabResultsPage({super.key});

  @override
  _LabResultsPageState createState() => _LabResultsPageState();
}

class _LabResultsPageState extends State<LabResultsPage> {
  List<String> _labResults = [];

  @override
  void initState() {
    super.initState();
    _loadLabResults();
  }

  Future<void> _loadLabResults() async {
    final results = await LabResultsStorage.getLabResults();
    setState(() {
      _labResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _labResults.isNotEmpty
            ? ListView.builder(
                itemCount: _labResults.length,
                itemBuilder: (context, index) {
                  final labResult = _labResults[index].split('|');
                  
                  // Check if labResult has the expected number of elements
                  if (labResult.length < 2) {
                    return const Card(
                      child: ListTile(
                        title: Text('Error: Invalid lab result format.'),
                      ),
                    );
                  }

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('Patient ID: ${labResult[0]}'),
                      subtitle: Text('Lab Result: ${labResult[1]}'),
                    ),
                  );
                },
              )
            : const Center(
                child: Text('No lab results available.'),
              ),
      ),
    );
  }
}
