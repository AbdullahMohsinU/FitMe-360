// ignore_for_file: deprecated_member_use, prefer_single_quotes, dead_code

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For haptic feedback
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // For custom fonts
import 'homescreen.dart';
import 'footsteptimer.dart';
import 'rememberlist.dart';
import 'login.dart';
import 'dietplan.dart';
import 'profilestatus.dart';

// Neon-inspired theme
final theme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF0A0F1C),
  primaryColor: const Color(0xFF00E5FF),
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF00E5FF),
    brightness: Brightness.dark,
    primary: const Color(0xFF00E5FF), // Neon cyan
    secondary: const Color(0xFFFF00FF), // Neon pink
    surface: const Color(0xFF121826),
  ),
  textTheme: GoogleFonts.poppinsTextTheme(
    const TextTheme().apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
          color: Color(0xFF00E5FF),
          blurRadius: 12,
        ),
      ],
    ),
    iconTheme: IconThemeData(color: Colors.white, size: 28),
  ),
  iconTheme: const IconThemeData(
    color: Color(0xFF00E5FF),
    size: 28,
    shadows: [
      Shadow(
        color: Color(0xFF00E5FF),
        blurRadius: 10,
      ),
    ],
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF121826),
    selectedItemColor: Color(0xFF00E5FF),
    unselectedItemColor: Colors.white70,
    showUnselectedLabels: false,
    selectedIconTheme: IconThemeData(
      color: Color(0xFF00E5FF),
      size: 34,
      shadows: [
        Shadow(
          color: Color(0xFF00E5FF),
          blurRadius: 15,
        ),
      ],
    ),
    unselectedIconTheme: IconThemeData(
      color: Colors.white54,
      size: 28,
    ),
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: Color(0xFF0A0F1C),
    scrimColor: Colors.black54,
  ),
  cardTheme: CardThemeData(
    color: const Color(0xFF121826),
    elevation: 8,
    shadowColor: Color(0xFF00E5FF),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  ),
);

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Widget> _pages = [
    HomeScreen(),
    const FootstepTimer(),
    const RememberList(),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: FutureBuilder<Map<String, String>>(
            future: _getUserInfo(),
            builder: (context, snapshot) {
              final name = snapshot.data?['name'] ?? 'User';
              return Text("Hello, $name!");
            },
          ),
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
        drawer: buildAppDrawer(context),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: _pages[_currentIndex],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: false,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                HapticFeedback.lightImpact();
                setState(() {
                  _currentIndex = index;
                  _animationController.reset();
                  _animationController.forward();
                });
              },
              backgroundColor: Colors.transparent,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined, size: 32),
                  activeIcon: Icon(Icons.home, size: 36),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.directions_run_outlined, size: 32),
                  activeIcon: Icon(Icons.directions_run, size: 36),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.note_outlined, size: 32),
                  activeIcon: Icon(Icons.note, size: 36),
                  label: '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Drawer widget
Widget buildAppDrawer(BuildContext context) {
  return Drawer(
    elevation: 4,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
    ),
    child: SafeArea(
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
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

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: imageProvider,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Color(0xFF00E5FF),
                            blurRadius: 12,
                          )
                        ],
                      ),
                    ),
                    Text(
                      'Welcome back!',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 👇 Expanded makes the list scrollable & avoids overflow
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

// Drawer Item with hover + glow effect
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
              ? (Matrix4.identity()..scale(1.03))
              : (Matrix4.identity()),
          decoration: BoxDecoration(
            color: isHovered
                ? theme.colorScheme.primary.withOpacity(0.12)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.6),
                      blurRadius: 14,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: ListTile(
            leading: Icon(icon, color: theme.iconTheme.color, size: 28),
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
