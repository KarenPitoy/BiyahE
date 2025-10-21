import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:biyahe_app/trip/circle_panel.dart';
import 'package:biyahe_app/trip/settings/settings_panel.dart';
import 'package:biyahe_app/dashboard.dart';
import 'package:biyahe_app/trip/notification.dart';

// Alias user_info to avoid conflicts with dashboard.dart
import '../user_info.dart' as user_info;

class TripPage extends StatefulWidget {
  final String fullname;
  final String phone;

  const TripPage({super.key, required this.fullname, required this.phone});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage>
    with SingleTickerProviderStateMixin {
  String? selectedLocation;
  final List<String> locations = [
    'Circle',
    'Friends',
    'Family',
    'Peer',
    'Wovie',
  ];
  int selectedIndex = 1;

  // Local copies for live updates
  late String fullname;
  late String phone;

  // Settings Panel Animation
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  bool _settingsVisible = false;

  @override
  void initState() {
    super.initState();
    selectedLocation = locations.first;
    fullname = widget.fullname;
    phone = widget.phone;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _toggleSettingsPanel() {
    setState(() => _settingsVisible = !_settingsVisible);
    if (_settingsVisible) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showFloatingSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF252554),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const CirclePanel(),
    );
  }

  void _showScanningSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color.fromARGB(255, 37, 37, 84),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.5,
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final LatLng mapCenter = LatLng(9.6485123082879, 123.8551513982076);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: mapCenter,
              zoom: 13.0,
              interactiveFlags: InteractiveFlag.all,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://cartodb-basemaps-a.global.ssl.fastly.net/light_all/{z}/{x}/{y}{r}.png",
                subdomains: const ['a', 'b', 'c', 'd'],
              ),
            ],
          ),

          // Top bar
          Positioned(
            top: 50,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Settings button
                IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: Color(0xFF252554),
                    size: 28,
                  ),
                  onPressed: _toggleSettingsPanel,
                ),

                // Dropdown center
                Expanded(
                  child: Center(
                    child: Container(
                      width: 180,
                      height: 42.34,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF252554),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: const Color(0xFF252554),
                          value: selectedLocation,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          items: locations.map((location) {
                            return DropdownMenuItem(
                              value: location,
                              child: Text(
                                location,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) =>
                              setState(() => selectedLocation = value),
                        ),
                      ),
                    ),
                  ),
                ),

                // Notifications button
                IconButton(
                  icon: const Icon(
                    Icons.notifications,
                    color: Color(0xFF252554),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Floating circle
          Positioned(
            bottom: 100,
            right: 20,
            child: GestureDetector(
              onTap: _showFloatingSheet,
              child: Container(
                width: 65,
                height: 65,
                decoration: const BoxDecoration(
                  color: Color(0xFF252554),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 6,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 35),
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
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DashboardPage(
                              fullname: user_info.UserInfo.fullname.value,
                              phone: user_info.UserInfo.phone.value,
                            ),
                          ),
                        ),
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
                        onTap: () => setState(() => selectedIndex = 1),
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
              builder: (context, child) {
                return FractionalTranslation(
                  translation: _slideAnimation.value,
                  child: child,
                );
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: SettingsPanel(
                    fullname: fullname,
                    phone: phone,
                    rfid: user_info.UserInfo.rfid.value,
                    userImageBytes: user_info.UserInfo.userImageBytes,
                    onNameChanged: (value) => setState(() {
                      fullname = value;
                      user_info.UserInfo.fullname.value = value;
                    }),
                    onPhoneChanged: (value) => setState(() {
                      phone = value;
                      user_info.UserInfo.phone.value = value;
                    }),
                    onRfidChanged: (value) => setState(() {
                      user_info.UserInfo.rfid.value = value;
                    }),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
