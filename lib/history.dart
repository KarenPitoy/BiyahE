import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int? selectedIndex; // To track which trip is expanded

  final List<Map<String, dynamic>> trips = [
    {
      "departure": "Tagbilaran",
      "arrival": "Panglao",
      "date": "2025-09-01",
      "time": "10:30 AM",
      "amount": 120.0,
      "total": 240.0,
      "passengers": [
        {"name": "Juan Dela Cruz", "avatar": "assets/profile.jpg"},
        {"name": "Maria Santos", "avatar": "assets/profile2.jpg"},
      ],
    },
    {
      "departure": "Cebu City",
      "arrival": "Tagbilaran",
      "date": "2025-08-28",
      "time": "03:15 PM",
      "amount": 150.0,
      "total": 450.0,
      "passengers": [
        {"name": "Pedro Reyes", "avatar": "assets/profile3.jpg"},
        {"name": "Ana Lopez", "avatar": "assets/profile4.jpg"},
        {"name": "Carlos Cruz", "avatar": "assets/profile5.jpg"},
      ],
    },
    {
      "departure": "Tubigon",
      "arrival": "Tagbilaran",
      "date": "2025-08-25",
      "time": "07:45 AM",
      "amount": 100.0,
      "total": 200.0,
      "passengers": [
        {"name": "Sophia Garcia", "avatar": "assets/profile6.jpg"},
        {"name": "Daniel Perez", "avatar": "assets/profile7.jpg"},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E5C),
      appBar: AppBar(
        title: const Text("History"),
        backgroundColor: const Color(0xFF252554),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          final isExpanded = selectedIndex == index;

          return Card(
            color: const Color(0xFF1F1F4D),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                key: Key(index.toString()),
                initiallyExpanded: isExpanded,
                onExpansionChanged: (expanded) {
                  setState(() {
                    selectedIndex = expanded
                        ? index
                        : null; // Only one stays open
                  });
                },
                title: Text(
                  "${trip['departure']} → ${trip['arrival']}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${trip['date']} • ${trip['time']}",
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                trailing: Text(
                  "₱${trip['total']}",
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF252554),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Amount Paid: ₱${trip['amount']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Total Paid: ₱${trip['total']}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Passengers:",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Column(
                          children: trip['passengers']
                              .map<Widget>(
                                (p) => ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: AssetImage(p['avatar']),
                                  ),
                                  title: Text(
                                    p['name'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
