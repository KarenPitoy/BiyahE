import 'package:flutter/material.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FAQs"),
        backgroundColor: const Color(0xFF252554),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF2E2E5C),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ExpansionTile(
            title: Text(
              "How do I book a trip?",
              style: TextStyle(color: Colors.white),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "You can book a trip directly from the Trip tab.",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Text("How do I pay?", style: TextStyle(color: Colors.white)),
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Payments can be made via GCash or cash on trip.",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
