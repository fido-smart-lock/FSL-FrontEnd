import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_main.dart';
import 'package:fido_smart_lock/pages/notification/noti_main.dart';
import 'package:fido_smart_lock/pages/user_settings/setting_main.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _navigateBottomBar(int index){
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
          color: Color.fromARGB(255, 23, 55, 102),
          onTap: _navigateBottomBar,
          items: [
            //Lock Management
            Icon(CupertinoIcons.padlock_solid, color: Colors.white, size: 30),
            //Notifications
            Icon(CupertinoIcons.bell_fill, color: Colors.white, size: 30),
            //Settings
            Icon(CupertinoIcons.person_fill, color: Colors.white, size: 30),
          ],
        ),
    );
  }
}
