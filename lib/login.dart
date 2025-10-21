import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'trip/trip.dart';
import 'dart:typed_data';
import 'user_info.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

Uint8List? userImageBytes;

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            // Background image
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset('assets/images/login.png', fit: BoxFit.cover),
            ),

            // Login form
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Logo
                    Padding(
                      padding: const EdgeInsets.only(top: 80),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),

                    // Form
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),

                            _buildInputField(
                              'Email',
                              _emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 15),
                            _buildInputField(
                              'Password',
                              _passwordController,
                              obscureText: true,
                            ),
                            const SizedBox(height: 25),

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
                                onPressed: _isLoading ? null : _loginUser,
                                child: _isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                      )
                                    : const Text(
                                        'Login',
                                        style: TextStyle(fontSize: 18),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF3B3B74),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFFFE433), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        if (label == 'Email' && !value.contains('@')) {
          return 'Enter a valid email';
        }
        return null;
      },
    );
  }

  Future<void> _loginUser() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      final user = await supabase
          .from('registration')
          .select()
          .eq('email', _emailController.text.trim())
          .eq('password', _passwordController.text)
          .maybeSingle();

      if (!mounted) return;

      if (user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );

        // After successful login
        UserInfo.fullname.value = user['fullname'] as String;
        UserInfo.phone.value = user['phone'].toString();
        UserInfo.balance.value = user['balance'].toString();
        UserInfo.rfid.value = user['RFID'].toString();

        // Optionally load profile image
        final profileUrl = user['profile_url'] as String?;
        if (profileUrl != null && profileUrl.isNotEmpty) {
          final response = await supabase.storage
              .from('profiles')
              .download(profileUrl);
          UserInfo.userImageBytes = response;
        }

        // Navigate to TripPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => TripPage(
              fullname: UserInfo.fullname.value,
              phone: UserInfo.phone.value,
              //   userImageBytes: UserInfo.userImageBytes,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Login error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
