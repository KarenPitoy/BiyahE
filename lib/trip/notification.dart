import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Example trip notifications
    final List<Map<String, String>> tripNotifications = [
      {"title": "Trip to Circle", "subtitle": "Arriving in 10 minutes"},
      {"title": "Trip to Friends’ Park", "subtitle": "Departed 5 minutes ago"},
      {"title": "Trip to Airport", "subtitle": "Scheduled for 2:30 PM"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notifications",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: tripNotifications.length,
        itemBuilder: (context, index) {
          final notif = tripNotifications[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            child: ListTile(
              leading: const Icon(
                Icons.directions_car,
                color: Colors.blueAccent,
              ),
              title: Text(
                notif["title"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                notif["subtitle"]!,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
            ),
          );
        },
      ),
    );
  }
}
