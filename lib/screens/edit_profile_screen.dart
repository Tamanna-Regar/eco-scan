import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController =
      TextEditingController(text: "Tamanna");
  final TextEditingController _emailController =
      TextEditingController(text: "tamanna3@gmail.com");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Here, in the future, you will add the API logic to update the database.

                // Show a confirmation message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Changes saved successfully!")),
                );

                // Go back to the previous screen
                Navigator.pop(context);
              },
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
