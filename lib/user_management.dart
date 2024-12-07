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
      appBar: AppBar(
        title: const Text("User Management"),
        backgroundColor: Colors.teal, // Set the AppBar color to teal for consistency
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildListTile(
              context,
              "Add User",
              const AddUserPage(),
            ),
            _buildListTile(
              context,
              "Delete User",
              const DeleteUserPage(),
            ),
            _buildListTile(
              context,
              "Update User Details",
              const UpdateUserPage(),
            ),
            _buildListTile(
              context,
              "View Users List",  // Changed from "Assign Roles"
              const UsersListPage(), // Navigate to UsersListPage
            ),
          ],
        ),
      ),
    );
  }

  // Reusable method to create ListTile widgets with consistent styling
  Widget _buildListTile(BuildContext context, String title, Widget page) {
    return Card(
      elevation: 4, // Add a shadow for a card effect
      margin: const EdgeInsets.symmetric(vertical: 8.0), // Margin between cards
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold, // Make the text bold
            color: Colors.teal, // Consistent color for the text
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.teal), // Icon for navigation
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
    );
  }
}
