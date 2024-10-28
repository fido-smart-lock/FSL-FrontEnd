import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/pages/notification/tabbar_contents/tabbar_contents.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotiMain extends StatelessWidget {
  const NotiMain({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Set the number of tabs here
      child: Background(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Label(size: 'xxl', label: 'Notifications', isBold: true),
          centerTitle: false,
          leadingWidth: NavigationToolbar.kMiddleSpacing,
          bottom: const TabBar(
            labelColor: Colors.white, // Active tab color
            unselectedLabelColor: Colors.white38, // Inactive tab color
            indicatorColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 10.0),
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                icon: Icon(CupertinoIcons.exclamationmark_shield),
                text: 'Warning',
              ),
              Tab(
                icon: Icon(CupertinoIcons.bell),
                text: 'Request',
              ),
              Tab(
                icon: Icon(CupertinoIcons.check_mark_circled),
                text: 'Connected',
              ),
              Tab(
                icon: Icon(CupertinoIcons.ellipses_bubble),
                text: 'Other',
              ),
            ],
          ),
        ),
        child: TabBarView(
          children: <Widget>[
            TabBarContents(mode: 'warning', subMode: 'main'),
            TabBarContents(mode: 'req'),
            TabBarContents(mode: 'connect'),
            TabBarContents(mode: 'other')
          ],
        ),
      ),
    );
  }
}
