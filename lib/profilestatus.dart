// ignore_for_file: library_private_types_in_public_api

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database_helper.dart';
import 'footsteptimer.dart';
import 'rememberlist.dart';
import 'login.dart';
import 'dietplan.dart';
import 'dashboard.dart';

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
        // ✅ Save the name for dashboard access
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
        setState(() {
          _image = file;
        });
      }
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', pickedFile.path);

      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Profile')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', const DashboardPage()),
            _buildDrawerItem(Icons.fastfood, 'Food', const Dietplan()),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign out'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : userData == null
                ? const Text('User not found')
                : Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.white70,
                    height: 600,
                    width: 300,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          GestureDetector(
                            onTap: pickImage,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _image != null
                                  ? FileImage(_image!)
                                  : const AssetImage('assets/content/image1.jpg') as ImageProvider,
                              child: _image == null
                                  ? const Icon(Icons.add_a_photo, color: Colors.white70)
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _buildUserInfo('Username', userData!['name']),
                          _buildUserInfo('Father Name', userData!['fathername']),
                          _buildUserInfo('Gender', userData!['gender']),
                          _buildUserInfo('Weight', userData!['weight']),
                          _buildUserInfo('Height', userData!['height']),
                          _buildUserInfo('Age', userData!['age']),
                          _buildUserInfo('DOB', userData!['dob']),
                          _buildUserInfo('Email', userData!['email']),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => _pages[index]),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Running',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.note),
            label: 'Notepad',
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: ${value ?? "N/A"}'),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
    );
  }
}
