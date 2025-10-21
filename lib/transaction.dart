import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  int? expandedIndex;

  final List<Map<String, dynamic>> transactions = [
    {
      "type": "Top Up",
      "amount": "+₱500.00",
      "method": "GCash",
      "date": "2025-09-01 10:30 AM",
      "icon": Icons.account_balance_wallet,
      "color": Colors.green,
      "reference": "TXN12345678",
    },
    {
      "type": "Payment",
      "amount": "-₱120.00",
      "method": "RFID Jeepney",
      "date": "2025-09-02 08:15 AM",
      "icon": Icons.directions_bus,
      "color": Colors.red,
      "reference": "TXN87654321",
    },
    {
      "type": "Refund",
      "amount": "+₱60.00",
      "method": "System Adjustment",
      "date": "2025-09-02 09:45 AM",
      "icon": Icons.refresh,
      "color": Colors.orange,
      "reference": "TXN54321678",
    },
    {
      "type": "Payment",
      "amount": "-₱75.00",
      "method": "E-Jeepney Ride",
      "date": "2025-09-03 05:30 PM",
      "icon": Icons.directions_car,
      "color": Colors.red,
      "reference": "TXN98765432",
    },
    {
      "type": "Top Up",
      "amount": "+₱300.00",
      "method": "Cash-in Counter",
      "date": "2025-09-04 01:00 PM",
      "icon": Icons.account_balance,
      "color": Colors.green,
      "reference": "TXN19283746",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E5C),
      appBar: AppBar(
        title: const Text("Transactions"),
        backgroundColor: const Color(0xFF252554),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: transactions.length,
        padding: const EdgeInsets.all(12),
        itemBuilder: (context, index) {
          final tx = transactions[index];
          final isExpanded = expandedIndex == index;

          return Card(
            color: const Color(0xFF1F1F4D),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: ExpansionTile(
              key: Key(index.toString()),
              initiallyExpanded: isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  expandedIndex = expanded ? index : null;
                });
              },
              leading: CircleAvatar(
                backgroundColor: tx["color"].withOpacity(0.2),
                child: Icon(tx["icon"], color: tx["color"]),
              ),
              title: Text(
                tx["type"],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                tx["date"],
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              trailing: Text(
                tx["amount"],
                style: TextStyle(
                  color: tx["color"],
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Method: ${tx["method"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Reference: ${tx["reference"]}",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
