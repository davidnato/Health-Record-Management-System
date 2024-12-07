import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users List"),
        backgroundColor: Colors.teal, // Set AppBar color to teal for consistency
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator with custom styling
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show styled error message if there's an error
              return Center(
                child: Text(
                  "Error: ${snapshot.error}",
                  style: const TextStyle(color: Colors.red, fontSize: 18),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              // Show message if no user records found
              return const Center(child: Text("No user records found."));
            } else {
              // Data exists, display it in a ListView
              final userDocs = snapshot.data!.docs;

              return ListView.builder(
                itemCount: userDocs.length,
                itemBuilder: (context, index) {
                  final userData = userDocs[index].data() as Map<String, dynamic>;

                  // Format the createdAt date
                  final createdAt = (userData['createdAt'] as Timestamp?)?.toDate();
                  final formattedDate = createdAt != null
                      ? DateFormat('yyyy-MM-dd HH:mm').format(createdAt)
                      : 'N/A';

                  return Card(
                    elevation: 5, // Add elevation for card shadow
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners for cards
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16.0), // Padding for ListTile
                      title: Text(
                        userData['fullname'] ?? 'No Name',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'Email: ${userData['email'] ?? 'N/A'}\n'
                        'Role: ${userData['role'] ?? 'N/A'}\n'
                        'Phone: ${userData['phone'] ?? 'N/A'}\n'
                        'Address: ${userData['address'] ?? 'N/A'}\n'
                        'Password: ${userData['password'] ?? 'N/A'}\n'
                        'Created At: $formattedDate',
                        style: const TextStyle(fontSize: 14),
                      ),
                      onTap: () {
                        // You can add more detailed actions here if needed
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
