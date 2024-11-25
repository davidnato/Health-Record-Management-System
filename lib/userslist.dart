import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  Future<List<Map<String, dynamic>>> _getUsersFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? usersJson = prefs.getStringList('users'); // Fetch the stored user list
    if (usersJson == null) return []; // Return an empty list if no data found

    // Decode the list of JSON strings into Dart objects
    return usersJson.map((user) => jsonDecode(user) as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getUsersFromSharedPreferences(), // Fetch users from SharedPreferences
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No users available'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user['full_name']),
                subtitle: Text('Role: ${user['role']}'),
              );
            },
          );
        },
      ),
    );
  }
}
