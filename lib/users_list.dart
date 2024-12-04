import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Users List")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while waiting for data
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // Show error message if there's an error
              return Center(child: Text("Error: ${snapshot.error}"));
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

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(userData['fullname'] ?? 'No Name'),
                      subtitle: Text(
                          'Email: ${userData['email'] ?? 'N/A'}\n'
                          'Role: ${userData['role'] ?? 'N/A'}\n'
                          'Phone: ${userData['phone'] ?? 'N/A'}\n'
                          'Address: ${userData['address'] ?? 'N/A'}\n'
                          'Password: ${userData['password'] ?? 'N/A'}\n'
                          'Created At: ${userData['createdAt']?.toDate().toString() ?? 'N/A'}'),
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
