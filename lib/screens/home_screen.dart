import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import zaroori hai
import 'scan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _scannedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  // SharedPreferences se count load karne ka function
  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _scannedCount = prefs.getInt('scanned_count') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Eco-Scan"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Hi Tamanna!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const Text("Let's keep the earth clean.",
                style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // _scannedCount variable ka use yahan ho raha hai
                _buildStatCard(
                    "Scanned", _scannedCount.toString(), Icons.qr_code_scanner),
                _buildStatCard(
                    "Recycled", _scannedCount.toString(), Icons.recycling),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () async {
                  // ScanScreen se wapas aane par stats refresh karne ke liye await
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const ScanScreen()));
                  _loadStats();
                },
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: const Icon(Icons.camera_alt,
                      size: 60, color: Colors.white),
                ),
              ),
            ),
            const Center(
                child: Text("Tap to Scan",
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String count, IconData icon) {
    return Card(
      elevation: 4,
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, color: Colors.green),
            Text(count,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(title),
          ],
        ),
      ),
    );
  }
}
