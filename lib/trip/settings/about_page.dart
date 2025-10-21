import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About BiyahE"),
        backgroundColor: const Color(0xFF252554),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF2E2E5C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 🔹 App Logo
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.yellow,
                child: Image.asset(
                  "assets/logo.png", // replace with your app logo
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 App Name
            const Text(
              "BiyahE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 App Description
            const Text(
              "BiyahE makes your daily trips smooth, secure, and hassle-free. "
              "Manage your rides, payments, and track your trips all in one app. "
              "Perfect for everyone — kids, adults, and the elderly!",
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // 🔹 Version Info Card
            Card(
              color: const Color(0xFF303070),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.info, color: Colors.white),
                title: const Text(
                  "Version",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  "1.0.0",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            // 🔹 Team Info Card
            Card(
              color: const Color(0xFF303070),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.people, color: Colors.white),
                title: const Text(
                  "Developed by Team Qpal",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  "Creating smooth rides and modern transport solutions for everyone",
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text(
              "Thank you for choosing BiyahE! We hope your trips are always safe and enjoyable.",
              style: TextStyle(color: Colors.white70, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
