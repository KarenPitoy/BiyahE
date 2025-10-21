import 'package:flutter/material.dart';

class CirclePanel extends StatefulWidget {
  const CirclePanel({super.key});

  @override
  State<CirclePanel> createState() => _CirclePanelState();
}

class _CirclePanelState extends State<CirclePanel> {
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, String>> friends = [
    {"name": "Alice", "category": "Friend"},
    {"name": "John", "category": "Partner"},
    {"name": "Maria", "category": "Family"},
  ];

  List<Map<String, String>> plitiFriends = [];

  @override
  Widget build(BuildContext context) {
    final filteredFriends = _searchController.text.isEmpty
        ? friends
        : friends
              .where(
                (f) => f["name"]!.toLowerCase().contains(
                  _searchController.text.toLowerCase(),
                ),
              )
              .toList();

    return FractionallySizedBox(
      heightFactor: 0.6,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top line indicator
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Search bar + Add Friend button
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Search friends",
                      hintStyle: const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: const Color(0xFF252554),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.white54,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _showAddNewFriendDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.black),
                  label: const Text(
                    "Add",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Friends list (scrollable)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListView.separated(
                  clipBehavior: Clip.none,
                  itemCount: filteredFriends.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final friend = filteredFriends[index];
                    final isAdded = plitiFriends.contains(friend);
                    return _buildFriendCard(friend, isAdded);
                  },
                ),
              ),
            ),

            // Fixed Pliti friends panel
            if (plitiFriends.isNotEmpty)
              SizedBox(height: 100, child: _buildPlitiPanel()),
          ],
        ),
      ),
    );
  }

  // Friend card with add/check button
  Widget _buildFriendCard(Map<String, String> friend, bool isAdded) {
    return Container(
      width: double.infinity,
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF252554),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 6,
            offset: Offset(0, 4), // shadow primarily below
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage("assets/profile.jpg"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  friend["name"]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  friend["category"]!,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black45,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: Icon(
                isAdded ? Icons.check : Icons.add,
                color: Colors.black,
              ),
              onPressed: () {
                if (!isAdded) {
                  _showSimpleAddDialog(friend);
                } else {
                  setState(() => plitiFriends.remove(friend));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Simple confirmation dialog to add friend to Pliti
  void _showSimpleAddDialog(Map<String, String> friend) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add to Pliti"),
          content: Text("Do you want to add ${friend['name']} to your Pliti?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() => plitiFriends.add(friend));
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Dialog to add a completely new friend
  void _showAddNewFriendDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController rfidController = TextEditingController();
    String selectedCategory = 'Friend';
    final categories = ['Friend', 'Family', 'Partner', 'Peer', 'Wovie'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Friend"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(hintText: "Name"),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: const InputDecoration(
                  labelText: "Category",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                items: categories
                    .map(
                      (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) selectedCategory = value;
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: rfidController,
                decoration: const InputDecoration(hintText: "RFID Number"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    rfidController.text.isNotEmpty) {
                  setState(() {
                    friends.add({
                      "name": nameController.text,
                      "category": selectedCategory,
                      "rfid": rfidController.text,
                    });
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  // Horizontal Pliti panel
  Widget _buildPlitiPanel() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[800],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 6, offset: Offset(2, 2)),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: plitiFriends.length,
        itemBuilder: (context, index) {
          final friend = plitiFriends[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: const AssetImage("assets/profile.jpg"),
                ),
                const SizedBox(height: 4),
                Text(
                  friend["name"]!,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
