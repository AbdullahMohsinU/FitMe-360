// ignore_for_file: prefer_single_quotes, deprecated_member_use, dead_code

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard.dart';
import 'dietplan.dart';
import 'profilestatus.dart';
import 'login.dart';

class HealthPlanScreen extends StatefulWidget {
  const HealthPlanScreen({super.key});

  @override
  State<HealthPlanScreen> createState() => _HealthPlanScreenState();
}

class _HealthPlanScreenState extends State<HealthPlanScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _goalController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildAppDrawer(context),
      appBar: AppBar(
        title: const Text("Health Plan"),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 23, 27, 255),
                Color.fromARGB(255, 58, 137, 255),
                Color.fromARGB(255, 0, 102, 255)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0F1C), Color(0xFF121826)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set Your Health Plan",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.cyanAccent,
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Neon Text Field 1
              _buildNeonTextField(
                controller: _goalController,
                hint: "Enter your fitness goal",
                icon: Icons.flag,
              ),
              const SizedBox(height: 20),

              // Neon Text Field 2
              _buildNeonTextField(
                controller: _noteController,
                hint: "Add notes or special instructions",
                icon: Icons.note,
                maxLines: 3,
              ),
              const SizedBox(height: 30),

              // Save Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Health plan saved successfully!"),
                        backgroundColor: Colors.blueAccent,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    shadowColor: Colors.cyanAccent,
                    elevation: 12,
                  ),
                  icon: const Icon(Icons.check_circle, size: 26),
                  label: Text(
                    "Save Plan",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Neon glowing textfield widget
Widget _buildNeonTextField({
  required TextEditingController controller,
  required String hint,
  required IconData icon,
  int maxLines = 1,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    style: const TextStyle(color: Colors.white, fontSize: 16),
    decoration: InputDecoration(
      filled: true,
      fillColor: const Color(0xFF121826),
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white70),
      prefixIcon: Icon(icon, color: Colors.cyanAccent),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.cyanAccent, width: 2.5),
      ),
    ),
  );
}

// Neon Drawer (reuse from dashboard.dart)
// Neon Drawer (fixed with dark theme background)
Widget buildAppDrawer(BuildContext context) {
  return Drawer(
    elevation: 4,
    backgroundColor: const Color(0xFF0A0F1C), // ✅ dark background
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
    ),
    child: SafeArea(
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              
            ),
            child: FutureBuilder<Map<String, String>>(
              future: _getUserInfo(),
              builder: (context, snapshot) {
                final name = snapshot.data?['name'] ?? 'User';
                final profileImage = snapshot.data?['profile_image'];
                ImageProvider imageProvider;

                if (profileImage != null &&
                    profileImage.isNotEmpty &&
                    File(profileImage).existsSync()) {
                  imageProvider = FileImage(File(profileImage));
                } else {
                  imageProvider = const AssetImage('assets/content/profile.jpg');
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: imageProvider,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              shadows: [
                                Shadow(
                                  color: Colors.cyanAccent,
                                  blurRadius: 12,
                                )
                              ],
                            ),
                          ),
                          Text(
                            "Stay Healthy!",
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          // Drawer items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(context,
                    icon: Icons.dashboard,
                    title: 'Dashboard',
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DashboardPage()));
                    }),
                _buildDrawerItem(context,
                    icon: Icons.fastfood,
                    title: 'Food',
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Dietplan()));
                    }),
                _buildDrawerItem(context,
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const STATUS()));
                    }),
                _buildDrawerItem(context,
                    icon: Icons.logout,
                    title: 'Sign out',
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    }),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Drawer item with neon hover
Widget _buildDrawerItem(
  BuildContext context, {
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      bool isHovered = false;
      return MouseRegion(
        onEnter: (_) => setState(() => isHovered = true),
        onExit: (_) => setState(() => isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          transform: isHovered
              ? (Matrix4.identity()..scale(1.05))
              : (Matrix4.identity()),
          decoration: BoxDecoration(
            color: isHovered ? Colors.cyan.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.6),
                      blurRadius: 14,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: ListTile(
            leading: Icon(icon, color: Colors.cyanAccent, size: 28),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            onTap: onTap,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          ),
        ),
      );
    },
  );
}

// Fetch user info
Future<Map<String, String>> _getUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  return {
    'name': prefs.getString('name') ?? 'User',
    'profile_image': prefs.getString('profile_image') ?? '',
  };
}
