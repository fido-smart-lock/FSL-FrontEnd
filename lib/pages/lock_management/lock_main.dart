import 'package:fido_smart_lock/component/atoms/background.dart';
import 'package:fido_smart_lock/component/atoms/dropdown_capsule.dart';
import 'package:fido_smart_lock/component/atoms/label.dart';
import 'package:fido_smart_lock/component/atoms/lock_card.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_create.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class LockMain extends StatelessWidget {
  static const List<String> dropdownItems = [
    "Home",
    "Office",
    "Airbnbbbbb",
  ];
  final String name = 'Jonathan';
  static final List<Map<String, String>> data = [
    {
      'img':
          'https://i.postimg.cc/1tD3M3D2/front-Door.png',
      'name': 'Front Door',
    },
    {
      'img':
          'https://i.postimg.cc/BbMswLbY/living-Room.png',
      'name': 'Living Room',
    },
    // Add more data as needed
  ];

  const LockMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: Container(
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ProfilePicture(
                    name: 'Jonathan Smith',
                    radius: 35,
                    fontsize: 21,
                    img:
                        'https://i.postimg.cc/jdtLgPgX/jonathan-Smith.png'),
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
                    MainHeaderLabel(label: 'Good Day', name: name, isBold: true),
                    SubHeaderLabel(label: 'Manage Your Locks'),
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
                      img: item['img']!,
                      name: item['name']!,
                      onTap: () {
                        // print('in the detail of $name');
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => DetailPage(name: item['name']!),
                        //   ),
                        // );
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
      ),
    );
  }
}
