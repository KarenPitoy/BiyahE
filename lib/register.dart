import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 10) Navigator.pop(context);
        },
        child: Stack(
          children: [
            // Background
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                'assets/images/register_bg.png',
                fit: BoxFit.cover,
              ),
            ),
            // Form
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                reverse: true,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Create an Account",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Please fill the input below",
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 20),

                      _buildInputField("Full Name", _fullNameController),
                      const SizedBox(height: 15),
                      _buildInputField(
                        "Phone",
                        _phoneController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        "Email",
                        _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        "Password",
                        _passwordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 15),
                      _buildInputField(
                        "Confirm Password",
                        _confirmPasswordController,
                        obscureText: true,
                      ),
                      const SizedBox(height: 25),

                      // Terms checkbox
                      SizedBox(
                        width: 322,
                        child: CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: const Color(0xFFFFE433),
                          title: const Text(
                            "I agree to the Terms and Conditions",
                            style: TextStyle(color: Colors.white70),
                          ),
                          value: _agreeToTerms,
                          onChanged: (bool? value) {
                            setState(() => _agreeToTerms = value ?? false);
                          },
                        ),
                      ),
                      const SizedBox(height: 10),

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
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            if (!_agreeToTerms) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "You must agree to the Terms and Conditions",
                                  ),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            if (_formKey.currentState!.validate()) {
                              _registerUser();
                            }
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
            ),
          ],
        ),
      ),
    );
  }

  // Input builder (fixed version)
  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      width: 322,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFF3B3B74),
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 12,
          ), // ✅ keeps consistent height
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFFFE433), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';

          if (label == "Full Name") {
            final regex = RegExp(r'^[A-Za-z]+( [A-Za-z]+)*$');
            if (!regex.hasMatch(value)) {
              return "Full Name can only contain letters and single spaces";
            }
          }

          if (label == "Phone") {
            final regex = RegExp(r'^09\d{9}$');
            if (!regex.hasMatch(value)) {
              return "Phone must start with 09 and be 11 digits";
            }
          }

          if (label == "Email") {
            final regex = RegExp(
              r'^[\w-\.]+@(gmail\.com|yahoo\.com|icloud\.com)$',
              caseSensitive: false,
            );
            if (!regex.hasMatch(value)) {
              return "Email must be @gmail.com, @yahoo.com, or @icloud.com";
            }
          }

          if (label == "Password") {
            if (value.length < 8) {
              return "Password must be at least 8 characters";
            }
          }

          if (label == "Confirm Password" &&
              value != _passwordController.text) {
            return "Passwords do not match";
          }

          return null;
        },
      ),
    );
  }

  // Supabase insert function
  Future<void> _registerUser() async {
    final supabase = Supabase.instance.client;

    try {
      await supabase.from('registration').insert({
        'fullname': _fullNameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
      }).select();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );

      _fullNameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed! $e')));
    }
  }
}
