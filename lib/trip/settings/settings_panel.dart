import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'about_page.dart';
import 'change_pin_page.dart';
import 'close_account_page.dart';
import 'contact_us_page.dart';
import 'faqs_page.dart';
import 'premium_page.dart';
import 'whats_new_page.dart';
import '../../login.dart';
import '../../user_info.dart' as user_info;

class SettingsPanel extends StatefulWidget {
  final String fullname;
  final String phone;
  final String? rfid;
  final Uint8List? userImageBytes;

  final void Function(String)? onNameChanged;
  final void Function(String)? onPhoneChanged;
  final void Function(String)? onRfidChanged;

  const SettingsPanel({
    super.key,
    required this.fullname,
    required this.phone,
    this.rfid,
    this.userImageBytes,
    this.onNameChanged,
    this.onPhoneChanged,
    this.onRfidChanged,
  });

  @override
  State<SettingsPanel> createState() => _SettingsPanelState();
}

class _SettingsPanelState extends State<SettingsPanel> {
  Uint8List? _imageBytes;
  String? _profileUrl; //  holds Supabase profile URL
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageBytes = widget.userImageBytes;
    _loadProfileUrl(); //  load saved profile on open
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
      print("⚠️ Failed to load profile: $e");
    }
  }

  /// Pick image from gallery and upload
  Future<void> _pickFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _imageBytes = bytes);
      await _uploadToDatabase(bytes);
    }
  }

  /// Take photo with camera and upload
  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _imageBytes = bytes);
      await _uploadToDatabase(bytes);
    }
  }

  Future<void> _uploadToDatabase(Uint8List bytes) async {
    try {
      final supabase = Supabase.instance.client;
      final filePath = 'avatars/${widget.fullname.replaceAll(" ", "_")}.png';

      await supabase.storage
          .from('profiles')
          .uploadBinary(
            filePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      // Add cache buster so Flutter doesn’t reuse old cached image
      final publicUrl =
          "${supabase.storage.from('profiles').getPublicUrl(filePath)}?v=${DateTime.now().millisecondsSinceEpoch}";
      print("✅ Uploaded! Public URL: $publicUrl");

      await supabase
          .from('registration')
          .update({'profile': publicUrl})
          .eq('fullname', widget.fullname);

      setState(() {
        _profileUrl = publicUrl; // update UI instantly
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile picture updated successfully!')),
      );
    } catch (e) {
      print("Upload failed: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Upload failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: widget.fullname);
    final phoneController = TextEditingController(text: widget.phone);
    final rfidController = TextEditingController(text: widget.rfid ?? "");

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height,
          color: const Color(0xFF252554),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile frame with edit
                GestureDetector(
                  onTap: () => _showProfileOptions(
                    context,
                    nameController,
                    phoneController,
                    rfidController,
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF303070),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 35,
                          backgroundImage:
                              _profileUrl !=
                                  null // priority 1
                              ? NetworkImage(_profileUrl!)
                              : _imageBytes !=
                                    null // priority 2
                              ? MemoryImage(_imageBytes!)
                              : const AssetImage("assets/profile.jpg")
                                    as ImageProvider,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.fullname,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.phone,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        const Icon(Icons.edit, color: Colors.white),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Premium card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PremiumPage()),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFE433), Color(0xFFFFC107)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Go Premium",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Unlock exclusive features",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.star, color: Colors.black, size: 32),
                      ],
                    ),
                  ),
                ),

                // Other settings items
                _buildSettingsItem(Icons.fiber_new, "What's New", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const WhatsNewPage()),
                  );
                }),
                _buildSettingsItem(Icons.lock, "Change Password", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ChangePinPage()),
                  );
                }),
                _buildSettingsItem(Icons.close, "Close Account", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CloseAccountPage()),
                  );
                }),
                _buildSettingsItem(Icons.help_outline, "FAQs", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FaqsPage()),
                  );
                }),
                _buildSettingsItem(Icons.info_outline, "About", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AboutPage()),
                  );
                }),
                _buildSettingsItem(Icons.support_agent, "Contact Us", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ContactUsPage()),
                  );
                }),

                const Divider(color: Colors.white30, height: 30),

                // Log out
                _buildSettingsItem(Icons.logout, "Log Out", () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (route) => false,
                  );
                }, color: Colors.redAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.white,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color, fontSize: 16)),
      onTap: onTap,
    );
  }

  void _showProfileOptions(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController phoneController,
    TextEditingController rfidController,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF252554),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 20),

              // Full Name
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                onChanged: (value) {
                  widget.onNameChanged?.call(value);
                  user_info.UserInfo.fullname.value =
                      value; // Update shared state
                },
              ),
              const SizedBox(height: 12),

              // Phone
              TextField(
                controller: phoneController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                onChanged: (value) {
                  widget.onPhoneChanged?.call(value);
                  user_info.UserInfo.phone.value = value; // Update shared state
                },
              ),
              const SizedBox(height: 12),

              // RFID / Account No.
              TextField(
                controller: rfidController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Account No.",
                  labelStyle: TextStyle(color: Colors.white70),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                ),
                onChanged: (value) {
                  widget.onRfidChanged?.call(value);
                  user_info.UserInfo.rfid.value = value; // Update shared state
                },
              ),
              const SizedBox(height: 20),

              // Upload buttons
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.white),
                title: const Text(
                  "Choose from Gallery",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickFromGallery();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.white),
                title: const Text(
                  "Take Photo",
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
