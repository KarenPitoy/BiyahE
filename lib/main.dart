import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'register.dart';
import 'login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://musiimheammasnmegnnt.supabase.co', // from Supabase project settings
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im11c2lpbWhlYW1tYXNubWVnbm50Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTgwMTIwMTcsImV4cCI6MjA3MzU4ODAxN30.KH2Pckv8CM9iTbYRBIzSSxt7rZFCRDhhxIf06655mm8', // from Supabase project settings
  );

  runApp(const BiyahE());
}

class BiyahE extends StatelessWidget {
  const BiyahE({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiyahE',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/login_or_register.png',
              fit: BoxFit.cover,
            ),
          ),
          // Logo
          Align(
            alignment: const Alignment(0, -0.6),
            child: Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
            ),
          ),
          // Buttons
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Login Button
                  SizedBox(
                    width: 196,
                    height: 47,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFE433),
                        foregroundColor: const Color(0xFF252554),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Register Button
                  SizedBox(
                    width: 196,
                    height: 47,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xFFFFE433),
                          width: 4,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFFFE433),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
