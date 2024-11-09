import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/dropdown/dropdown_capsule.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/lock_card.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_create.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_detail/lock_detail.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LockMain extends StatelessWidget {
  static const List<String> dropdownItems = [
    "Home",
    "Office",
    "Airbnbbbbb",
  ];
  final String name = 'John';
  static final List<Map<String, String>> data = [
    {
      'img': 'https://i.postimg.cc/1tD3M3D2/front-Door.png',
      'lockName': 'Front Door',
    },
    {
      'img': 'https://i.postimg.cc/BbMswLbY/living-Room.png',
      'lockName': 'Living Room',
    },
    // Add more data as needed
  ];

  const LockMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Align(
        alignment: Alignment.topCenter,
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(
                      'https://i.postimg.cc/jdtLgPgX/jonathan-Smith.png')),
              DropdownCapsule(items: dropdownItems),
            ],
          ),
          const Gap(20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Label(
                      size: 'xxl', label: 'Good Day', name: name, isBold: true),
                  Label(size: 'l', label: 'Manage Your Locks'),
                ],
              )
            ],
          ),
          const Gap(30),
          Expanded(
            child: GridView.count(
              padding: EdgeInsets.zero,
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 20.0,
              children: [
                ...data.map((item) {
                  return LockCard(
                    img: item['img'],
                    name: item['lockName']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LockDetail(
                              lockName: item['lockName']!,
                              lockImg: item['img'],
                              lockLocation: 'Home'),
                        ),
                      );
                    },
                  );
                }),
                AddLockCard(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockCreate(),
                    ),
                  );
                })
              ],
            ),
          )
        ]),
      ),
    );
  }
}
