import 'package:flutter/material.dart';
import 'package:hrms/add_user.dart';
import 'package:hrms/delete_user.dart';
import 'package:hrms/update_user.dart';
import 'package:hrms/users_list.dart'; // Import the new users list page

class UserManagementPage extends StatelessWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Management")),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Add User"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddUserPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Delete User"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DeleteUserPage()),
              );
            },
          ),
          ListTile(
            title: const Text("Update User Details"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UpdateUserPage()),
              );
            },
          ),
          ListTile(
            title: const Text("View Users List"),  // Changed from "Assign Roles"
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const UsersListPage()), // Navigate to UsersListPage
              );
            },
          ),
        ],
      ),
    );
  }
}
