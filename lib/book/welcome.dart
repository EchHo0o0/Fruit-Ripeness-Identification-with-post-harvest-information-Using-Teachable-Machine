import 'dart:io';
import 'package:flutter/material.dart';
import 'package:harvi/authentication/mainscreen.dart';
import 'package:harvi/book/homeculture.dart';
import 'package:harvi/home/anouncebyadmin.dart';
import 'package:harvi/home/setting.dart'; // Settings screen
import 'package:harvi/scan/scann.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _fullName;
  String? _email;
  ImageProvider _avatarImage = const AssetImage('assets/logo.png');

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    final avatarPath = prefs.getString('profileImagePath'); // consistent key
    final fullName = prefs.getString('fullName') ?? 'No Name';
    final email = prefs.getString('email') ?? 'No Email';

    ImageProvider imageProvider = const AssetImage('assets/logo.png');
    if (avatarPath != null && await File(avatarPath).exists()) {
      imageProvider = FileImage(File(avatarPath));
    }

    setState(() {
      _avatarImage = imageProvider;
      _fullName = fullName;
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green[700],
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.white),
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
              child: Container(
                color: Colors.green.shade100,
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: _avatarImage,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _fullName ?? 'No Name',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email ?? 'No Email',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(
              icon: Icons.school,
              color: Colors.purple,
              text: 'Learning Guide',
              destination: const HorticultureScreen(),
            ),
            _buildDrawerItem(
              icon: Icons.scanner,
              color: Colors.red,
              text: 'Scan',
              destination: const Scann(),
            ),
            _buildDrawerItem(
              icon: Icons.announcement,
              color: Colors.yellow.shade800,
              text: 'Announcement',
              destination: UserAnnouncementScreen(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Card(
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.settings, color: Colors.grey),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    ).then((_) {
                      _loadProfileData(); // Reload profile data after returning from settings
                    });
                  },
                ),
              ),
            ),
            const Spacer(),
            _buildDrawerItem(
              icon: Icons.logout,
              color: Colors.black,
              text: 'Log Out',
              destination: MainScreen(),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          'Welcome to Harvi!',
          style: TextStyle(fontSize: 22, color: Colors.green[800]),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required Color color,
    required String text,
    required Widget destination,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        elevation: 2,
        child: ListTile(
          leading: Icon(icon, color: color),
          title: Text(text),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => destination),
            );
          },
        ),
      ),
    );
  }
}
