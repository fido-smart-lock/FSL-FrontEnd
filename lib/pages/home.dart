import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_main.dart';
import 'package:fido_smart_lock/pages/notification/noti_main.dart';
import 'package:fido_smart_lock/pages/user_settings/setting_main.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final int initialIndex;
  
  const Home({super.key, this.initialIndex = 0}); // Default index is 0 (LockMain)

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Initialize with the passed index
  }

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    const LockMain(),
    const NotiMain(),
    const SettingsMain()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.transparent,
        color: const Color.fromARGB(255, 23, 55, 102),
        onTap: _navigateBottomBar,
        items: const [
          Icon(CupertinoIcons.padlock_solid, color: Colors.white, size: 30),
          Icon(CupertinoIcons.bell_fill, color: Colors.white, size: 30),
          Icon(CupertinoIcons.person_fill, color: Colors.white, size: 30),
        ],
      ),
    );
  }
}
