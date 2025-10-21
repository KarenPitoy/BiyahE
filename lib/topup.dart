import 'package:flutter/material.dart';

class TopUpPage extends StatefulWidget {
  const TopUpPage({super.key});

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedMethod = "GCash";

  final List<String> _methods = ["GCash", "PayMaya"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E5C),
      appBar: AppBar(
        title: const Text("Top Up"),
        backgroundColor: const Color(0xFF252554),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Current Balance
            const Text(
              "Current Balance",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              "₱100.00",
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Enter Amount
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white, fontSize: 18),
              decoration: InputDecoration(
                prefixText: "₱ ",
                prefixStyle: const TextStyle(color: Colors.white, fontSize: 18),
                hintText: "Enter amount",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: const Color(0xFF1F1F4D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 🔹 Quick Amounts
            Wrap(
              spacing: 10,
              children: [50, 100, 200, 500].map((amount) {
                return ChoiceChip(
                  label: Text("₱$amount"),
                  selected: _amountController.text == amount.toString(),
                  onSelected: (_) {
                    setState(() {
                      _amountController.text = amount.toString();
                    });
                  },
                  backgroundColor: Colors.white12,
                  selectedColor: Colors.yellow,
                  labelStyle: TextStyle(
                    color: _amountController.text == amount.toString()
                        ? Colors.black
                        : const Color.fromARGB(255, 0, 0, 0),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            // 🔹 Payment Method
            const Text(
              "Payment Method",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedMethod,
              dropdownColor: const Color(0xFF1F1F4D),
              items: _methods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(
                    method,
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMethod = value!;
                });
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1F1F4D),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),

            // 🔹 Confirm Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Top up ₱${_amountController.text} via $_selectedMethod",
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Proceed",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
