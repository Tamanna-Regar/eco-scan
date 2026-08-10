import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
import 'result_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  XFile? _image;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) return;

    setState(() {
      _isLoading = true;
    });

    String url = kIsWeb
        ? 'http://localhost:8000/api/predict/'
        : 'http://10.0.2.2:8000/api/predict/';
    var uri = Uri.parse(url);

    try {
      var request = http.MultipartRequest('POST', uri);

      if (kIsWeb) {
        Uint8List bytes = await _image!.readAsBytes();
        request.files.add(http.MultipartFile.fromBytes('image', bytes,
            filename: 'upload.jpg'));
      } else {
        request.files
            .add(await http.MultipartFile.fromPath('image', _image!.path));
      }

      var response = await request.send().timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        var data = jsonDecode(responseBody);

        // --- COUNT UPDATE LOGIC ---
        final prefs = await SharedPreferences.getInstance();
        int currentScanned = prefs.getInt('scanned_count') ?? 0;
        await prefs.setInt('scanned_count', currentScanned + 1);
        // ---------------------------

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ResultScreen(
                itemName: data['prediction'] ?? "Unknown",
                isRecyclable: data['is_recyclable'] ?? true,
                tip: data['tip'] ?? "Please recycle responsibly.",
              ),
            ),
          );
        }
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Scan Waste"), backgroundColor: Colors.green),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _image == null
                      ? const Icon(Icons.camera_alt,
                          size: 100, color: Colors.grey)
                      : kIsWeb
                          ? Image.network(_image!.path, height: 300)
                          : Image.file(File(_image!.path), height: 300),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      onPressed: _pickImage, child: const Text("Capture")),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: _uploadImage,
                    child: const Text("Upload & Scan"),
                  ),
                ],
              ),
      ),
    );
  }
}
