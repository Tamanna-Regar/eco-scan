import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String itemName;
  final bool isRecyclable;
  final String tip;

  const ResultScreen({
    super.key,
    required this.itemName,
    required this.isRecyclable,
    required this.tip,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Scan Result"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Icon(
              isRecyclable ? Icons.check_circle : Icons.warning,
              color: isRecyclable ? Colors.green : Colors.orange,
              size: 100,
            ),
            const SizedBox(height: 20),
            Text(itemName,
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              isRecyclable
                  ? "This item is Recyclable!"
                  : "This item is NOT recyclable.",
              style: TextStyle(
                  fontSize: 18,
                  color: isRecyclable ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10)),
              child: Text("Tip: $tip", style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Scan Another Item"),
            ),
          ],
        ),
      ),
    );
  }
}
