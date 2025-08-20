// ignore_for_file: library_private_types_in_public_api, prefer_single_quotes, deprecated_member_use, dead_code

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database_helper.dart';
import 'footsteptimer.dart';
import 'rememberlist.dart';
import 'login.dart';
import 'dietplan.dart';
import 'dashboard.dart';

// Neon theme
final neonTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0A0F1C),
  primaryColor: const Color(0xFF00E5FF),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00E5FF),
    brightness: Brightness.dark,
    primary: const Color(0xFF00E5FF),
    secondary: const Color(0xFFFF00FF),
    surface: const Color(0xFF121826),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    const TextTheme().apply(bodyColor: Colors.white, displayColor: Colors.white),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Color(0xFF00E5FF),
      fontSize: 20,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(color: Color(0xFF00E5FF), blurRadius: 12, offset: Offset(0, 0)),
      ],
    ),
    iconTheme: IconThemeData(color: Colors.white, size: 28),
  ),
);

class STATUS extends StatefulWidget {
  const STATUS({super.key});

  @override
  _STATUSState createState() => _STATUSState();
}

class _STATUSState extends State<STATUS> {
  Map<String, dynamic>? userData;
  bool isLoading = true;
  File? _image;
  int _currentIndex = 0;

  // track which drawer item is selected
  String _selectedDrawer = "Profile";

  final List<Widget> _pages = const [
    DashboardPage(),
    FootstepTimer(),
    RememberList(),
  ];

  @override
  void initState() {
    super.initState();
    loadUser();
    loadImage();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      final user = await DatabaseHelper().getUser(email, password);

      if (user != null) {
        await prefs.setString('name', user['name'] ?? '');
        setState(() {
          userData = user;
          isLoading = false;
        });
      } else {
        setState(() {
          userData = null;
          isLoading = false;
        });
      }
    } else {
      setState(() {
        userData = null;
        isLoading = false;
      });
    }
  }

  Future<void> loadImage() async {
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString('profile_image');
    if (path != null) {
      final file = File(path);
      if (await file.exists()) {
        setState(() => _image = file);
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: neonTheme,
      child: Scaffold(
        backgroundColor: neonTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text(
            'My Profile',
            style: TextStyle(
              color: Color(0xFF00E5FF),
              fontSize: 20,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(color: Color(0xFF00E5FF), blurRadius: 12, offset: Offset(0, 0)),
              ],
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 23, 27, 255),
                  Color.fromARGB(255, 58, 137, 255),
                  Color.fromARGB(255, 0, 102, 255),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        drawer: _buildProfileDrawer(),
        body: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Color(0xFF00E5FF))
              : userData == null
                  ? const Text(
                      "⚠️ User not found",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        shadows: [
                          Shadow(
                            color: Colors.redAccent,
                            blurRadius: 10,
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: neonTheme.colorScheme.primary.withOpacity(0.8),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: _getProfileImage(),
                                child: _image == null
                                    ? const Icon(Icons.add_a_photo,
                                        color: Colors.white70, size: 30)
                                    : null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          ..._buildUserInfoList(),
                        ],
                      ),
                    ),
        ),
        bottomNavigationBar: _buildNeonBottomBar(),
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (_image != null) {
      return FileImage(_image!);
    } else if (userData != null && userData!['profile_image'] != null) {
      return FileImage(File(userData!['profile_image']));
    } else {
      return const AssetImage('assets/content/profile.jpg');
    }
  }

  // Neon-styled info cards
  List<Widget> _buildUserInfoList() {
    return [
      _buildUserCard('👤 Username', userData!['name']),
      _buildUserCard('👨‍👧 Father Name', userData!['fathername']),
      _buildUserCard('⚧ Gender', userData!['gender']),
      _buildUserCard('⚖ Weight', '${userData!['weight']} kg'),
      _buildUserCard('📏 Height', '${userData!['height']} cm'),
      _buildUserCard('🎂 Age', '${userData!['age']} yrs'),
      _buildUserCard('📅 DOB', userData!['dob']),
      _buildUserCard('✉ Email', userData!['email']),
    ];
  }

  Widget _buildUserCard(String label, dynamic value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: neonTheme.colorScheme.surface,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.star, color: Color(0xFF00E5FF)),
        title: Text(
          label,
          style: GoogleFonts.poppins(
            color: const Color(0xFF00E5FF),
            fontWeight: FontWeight.w500,
            fontSize: 16,
            shadows: [
              Shadow(
                color: Color(0xFF00E5FF),
                blurRadius: 8,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        subtitle: Text(
          value?.toString() ?? "N/A",
          style: GoogleFonts.poppins(
            color: Colors.white70,
            fontSize: 14,
            shadows: [
              Shadow(
                color: Colors.white70,
                blurRadius: 4,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Neon bottom nav
  Widget _buildNeonBottomBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: neonTheme.colorScheme.primary.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          HapticFeedback.lightImpact();
          setState(() => _currentIndex = index);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF00E5FF),
        unselectedItemColor: Colors.white70,
        selectedLabelStyle: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          shadows: [
            const Shadow(
              color: Color(0xFF00E5FF),
              blurRadius: 6,
              offset: Offset(0, 0),
            ),
          ],
        ),
        unselectedLabelStyle: GoogleFonts.poppins(),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run_outlined),
            activeIcon: Icon(Icons.directions_run),
            label: 'Running',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note_outlined),
            activeIcon: Icon(Icons.note),
            label: 'Notepad',
          ),
        ],
      ),
    );
  }

  // Neon Drawer with hover + selected glow
  Widget _buildProfileDrawer() {
    return Drawer(
      elevation: 0,
      backgroundColor: const Color(0xFF0A0F1C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 45,
              backgroundImage: _getProfileImage(),
            ),
            const SizedBox(height: 12),
            Text(
              userData?['name'] ?? 'Guest User',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    color: neonTheme.colorScheme.primary.withOpacity(0.9),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
            Text(
              userData?['email'] ?? '',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 25),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _neonDrawerItem(Icons.dashboard, 'Dashboard', const DashboardPage()),
                  _neonDrawerItem(Icons.fastfood, 'Food', const Dietplan()),
                  _neonDrawerItem(Icons.person, 'Profile', const STATUS()),
                  _neonDrawerItem(Icons.logout, 'Sign out', const LoginPage()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Drawer item with hover + selected effect
  Widget _neonDrawerItem(IconData icon, String title, Widget page) {
    return StatefulBuilder(
      builder: (context, setState) {
        bool isHovered = false;
        final bool isSelected = _selectedDrawer == title;

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              gradient: isSelected || isHovered
                  ? LinearGradient(
                      colors: [
                        const Color(0xFF00E5FF).withOpacity(0.25),
                        neonTheme.colorScheme.secondary.withOpacity(0.25),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
              borderRadius: BorderRadius.circular(12),
              boxShadow: (isSelected || isHovered)
                  ? [
                      BoxShadow(
                        color: const Color(0xFF00E5FF).withOpacity(0.8),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ]
                  : [],
            ),
            child: ListTile(
              leading: Icon(
                icon,
                size: 26,
                color: isSelected
                    ? const Color(0xFF00E5FF)
                    : (isHovered ? neonTheme.colorScheme.secondary : Colors.white70),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isSelected
                      ? const Color(0xFF00E5FF)
                      : (isHovered ? neonTheme.colorScheme.secondary : Colors.white),
                  shadows: [
                    Shadow(
                      color: isSelected
                          ? const Color(0xFF00E5FF)
                          : (isHovered
                              ? neonTheme.colorScheme.secondary.withOpacity(0.9)
                              : neonTheme.colorScheme.primary.withOpacity(0.6)),
                      blurRadius: isSelected ? 14 : (isHovered ? 12 : 6),
                    ),
                  ],
                ),
              ),
              onTap: () {
                setState(() => _selectedDrawer = title);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => page),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
