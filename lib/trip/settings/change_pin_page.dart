import 'package:flutter/material.dart';

class ChangePinPage extends StatefulWidget {
  const ChangePinPage({super.key});

  @override
  State<ChangePinPage> createState() => _ChangePinPageState();
}

class _ChangePinPageState extends State<ChangePinPage> {
  final oldPinController = TextEditingController();
  final newPinController = TextEditingController();
  final confirmPinController = TextEditingController();

  // Optional: show/hide PIN
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  void _changePin() {
    final oldPin = oldPinController.text;
    final newPin = newPinController.text;
    final confirmPin = confirmPinController.text;

    if (oldPin.isEmpty || newPin.isEmpty || confirmPin.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    if (newPin != confirmPin) {
      _showMessage("New Password and Confirm Password do not match");
      return;
    }

    // 🔹 Add your logic here to update PIN (API or local)
    _showMessage("Password changed successfully!");
    // Optionally, clear fields
    oldPinController.clear();
    newPinController.clear();
    confirmPinController.clear();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Password"),
        backgroundColor: const Color(0xFF252554),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFF2E2E5C),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPinField(
              "Enter old Password",
              oldPinController,
              _obscureOld,
              () => setState(() => _obscureOld = !_obscureOld),
            ),
            const SizedBox(height: 20),
            _buildPinField(
              "Enter new Password",
              newPinController,
              _obscureNew,
              () => setState(() => _obscureNew = !_obscureNew),
            ),
            const SizedBox(height: 20),
            _buildPinField(
              "Confirm new Password",
              confirmPinController,
              _obscureConfirm,
              () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _changePin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Confirm",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPinField(
    String label,
    TextEditingController controller,
    bool obscure,
    VoidCallback toggle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF3B3B74),
            border: const OutlineInputBorder(),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.white70),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility_off : Icons.visibility,
                color: Colors.white70,
              ),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }
}
