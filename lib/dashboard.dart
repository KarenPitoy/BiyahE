import 'package:biyahe_app/trip/trip.dart';
import 'package:flutter/material.dart';
import 'history.dart';
import 'transaction.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'topup.dart';
import '../trip/settings/settings_panel.dart';
import '../user_info.dart' as user_info;

class DashboardPage extends StatefulWidget {
  final String fullname;
  final String phone;

  const DashboardPage({super.key, required this.fullname, required this.phone});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  String? _profileUrl; // hold profile image URL

  // Settings Panel Animation
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _settingsVisible = false;

  @override
  void initState() {
    super.initState();

    // Initialize shared info
    user_info.UserInfo.fullname.value = widget.fullname;
    user_info.UserInfo.phone.value = widget.phone;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _loadProfileUrl(); // load saved profile from Supabase
  }

  Future<void> _loadProfileUrl() async {
    try {
      final response = await Supabase.instance.client
          .from('registration')
          .select('profile')
          .eq('fullname', widget.fullname)
          .maybeSingle();

      if (response != null && response['profile'] != null) {
        setState(() {
          _profileUrl = response['profile'] as String;
        });
      }
    } catch (e) {
      print("Failed to load profile URL: $e");
    }
  }

  void _toggleSettingsPanel() {
    setState(() => _settingsVisible = !_settingsVisible);
    if (_settingsVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  void _showScanningSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              color: Color(0xFF252554),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Scanning...",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Icon(Icons.phone_iphone, size: 80, color: Colors.blue),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFE433),
                    fixedSize: const Size(212, 54.32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E2E5C),
      body: Stack(
        children: [
          // Top profile
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: _profileUrl != null
                          ? NetworkImage(_profileUrl!) // 🔥 use uploaded URL
                          : const AssetImage("assets/profile.jpg")
                                as ImageProvider,
                    ),
                    const SizedBox(width: 12),
                    ValueListenableBuilder(
                      valueListenable: user_info.UserInfo.fullname,
                      builder: (context, value, child) {
                        return Text(
                          value.isEmpty ? "User" : value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: _toggleSettingsPanel,
                ),
              ],
            ),
          ),

          // Inside the Positioned top card (replace your previous Balance & RFID card)
          Positioned(
            top: 150,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1F4D),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 8,
                    offset: Offset(2, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Balance label
                  const Text(
                    "Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  ValueListenableBuilder(
                    valueListenable: user_info.UserInfo.balance,
                    builder: (context, value, child) {
                      return Text(
                        "₱$value",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Account No. label instead of RFID
                  const Text(
                    "Account No.",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  ValueListenableBuilder(
                    valueListenable: user_info.UserInfo.rfid,
                    builder: (context, value, child) {
                      return Text(
                        value.isEmpty ? "N/A" : value,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TopUpPage(),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Top Up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // History & Transactions buttons remain unchanged
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HistoryPage(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("History"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TransactionPage(),
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Transactions"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Bottom navbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 69,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(height: 69, color: const Color(0xFFF0F0F0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => selectedIndex = 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dashboard,
                              color: selectedIndex == 0
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Dashboard",
                              style: TextStyle(
                                color: selectedIndex == 0
                                    ? Colors.blue
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 70),
                      GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = 1);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TripPage(
                                fullname: user_info.UserInfo.fullname.value,
                                phone: user_info.UserInfo.phone.value,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.directions_car,
                              color: selectedIndex == 1
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Trip",
                              style: TextStyle(
                                color: selectedIndex == 1
                                    ? Colors.blue
                                    : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Pay button
          Positioned(
            bottom: 15,
            left: MediaQuery.of(context).size.width / 2 - 35,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _showScanningSheet,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    backgroundColor: Colors.yellow,
                    padding: const EdgeInsets.all(20),
                    elevation: 8,
                    shadowColor: Colors.black54,
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Pay",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Settings panel overlay
          if (_settingsVisible)
            GestureDetector(
              onTap: _toggleSettingsPanel,
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
          if (_settingsVisible)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) => FractionalTranslation(
                translation: _slideAnimation.value,
                child: child,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SettingsPanel(
                    fullname: user_info.UserInfo.fullname.value,
                    phone: user_info.UserInfo.phone.value,
                    rfid: user_info.UserInfo.rfid.value,
                    onNameChanged: (value) =>
                        user_info.UserInfo.fullname.value = value,
                    onPhoneChanged: (value) =>
                        user_info.UserInfo.phone.value = value,
                    onRfidChanged: (value) =>
                        user_info.UserInfo.rfid.value = value,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
