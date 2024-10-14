import 'package:fido_smart_lock/component/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/person_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminSettingMain extends StatelessWidget {
  const AdminSettingMain({
    super.key,
    required this.lockName,
    required this.lockLocation,
    required this.name,
    required this.role,
    required this.img,
  });

  final String lockName;
  final String lockLocation;
  final List<String> name;
  final List<String> role;
  final List<String> img;

  @override
  Widget build(BuildContext context) {
    return Background(
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MainHeaderLabel(
              label: lockName,
              isShadow: true,
            ),
            SubHeaderLabel(
              label: lockLocation,
              color: Colors.grey.shade300,
              isShadow: true,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              CupertinoIcons.person_add,
              size: 30,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
              ],
            ),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderLabel(label: 'Admin'),
          Expanded(
            child: ListView.builder(
              itemCount: img.length, // Assumes all lists have the same length
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Person(
                    img: img[index],
                    name: name[index],
                    role: role[index],
                    button: 'remove',
                    lockName: lockName,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
