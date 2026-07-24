import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image; // Ye variable photo store karega
  final ImagePicker _picker = ImagePicker();

  // Gallery se photo select karne ka function
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Profile"), backgroundColor: Colors.green),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Profile Picture
            GestureDetector(
              onTap: _pickImage, // Photo pe click karte hi gallery khulegi
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.green,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null
                    ? const Icon(Icons.camera_alt,
                        size: 50, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            const Text("Tamanna",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text("Student at Sangam University",
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),

            const ListTile(
                leading: Icon(Icons.email),
                title: Text("Email"),
                subtitle: Text("tamanna3@gmail.com")),
            const ListTile(
                leading: Icon(Icons.phone),
                title: Text("Phone"),
                subtitle: Text("+91 XXXXX XXXXX")),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen())),
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
