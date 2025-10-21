import 'package:flutter/material.dart';

class WhatsNewPage extends StatelessWidget {
  const WhatsNewPage({super.key});

  final List<Map<String, dynamic>> updates = const [
    {
      "title": "QR Payment",
      "date": "Sep 2025",
      "description":
          "Pay for your trips instantly using QR codes directly from your app wallet.",
    },
    {
      "title": "Live Trip Tracking",
      "date": "Aug 2025",
      "description":
          "Track your jeepney in real-time and see estimated arrival times.",
    },
    {
      "title": "Premium Plans",
      "date": "Jul 2025",
      "description":
          "Subscribe to premium for exclusive benefits like priority boarding and discounts.",
    },
    {
      "title": "Dashboard Upgrade",
      "date": "Jun 2025",
      "description":
          "Enjoy a smoother dashboard with easier navigation and quick access to your balance.",
    },
    {
      "title": "Performance Fixes",
      "date": "May 2025",
      "description":
          "Fixed login issues and improved GPS accuracy for a better experience.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What's New"),
        backgroundColor: const Color(0xFF252554),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF2E2E5C),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: updates.length,
        separatorBuilder: (context, index) =>
            const Divider(color: Colors.white24, height: 1),
        itemBuilder: (context, index) {
          final update = updates[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            title: Text(
              update["title"],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  update["date"],
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  update["description"],
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
            trailing: const Icon(Icons.new_releases, color: Colors.redAccent),
          );
        },
      ),
    );
  }
}
