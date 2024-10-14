import 'package:fido_smart_lock/component/background_lock_detail.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/lock_detail_card.dart';
import 'package:fido_smart_lock/component/security_status.dart';
import 'package:fido_smart_lock/pages/lock_management/admin_setting/admin_setting_main.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LockDetail extends StatelessWidget {
  final String lockName;
  final String? lockImg;
  final String lockLocation;

  const LockDetail({
    super.key,
    required this.lockName,
    this.lockImg,
    required this.lockLocation,
  });

  @override
  Widget build(BuildContext context) {
    return BackgroundLockDetail(
      imageUrl: lockImg,
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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LockSetting(
                        appBarTitle: 'Lock Setting',
                        img: lockImg,
                        name: lockName,
                        location: lockLocation),
                  ),
                );
              },
              child: Icon(
                CupertinoIcons.gear,
                size: 30,
                color: Colors.white,
                shadows: <Shadow>[
                  Shadow(
                      color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
                ],
              ),
            ),
          )
        ],
      ),
      child: Align(
        alignment: Alignment.topLeft,
        child: Column(
          children: [
            Gap(110),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [SecurityStatus(status: 'warning'), ScanButton()]),
            Gap(10),
            AdminCard(
              isManageable: true,
              people: 2,
              imageUrls: [
                'https://i.postimg.cc/jdtLgPgX/jonathan-Smith.png',
                'https://i.postimg.cc/85dPzp3S/josephine-Smith.png',
              ],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminSettingMain(
                        lockName: lockName,
                        lockLocation: lockLocation,
                        img: [
                          'https://i.postimg.cc/jdtLgPgX/jonathan-Smith.png',
                          'https://i.postimg.cc/85dPzp3S/josephine-Smith.png',
                        ],
                        name: ['Jonathan Smith', 'Josephine Smith'],
                        role: ['Admin', 'Admin'],
                        ),
                  ),
                );
              },
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconCard(cardType: 'member', people: 3, imageUrls: [
                  'https://i.postimg.cc/jSC54rWH/jane-Smith.png',
                  'https://i.postimg.cc/SRDScZk1/jacob-Smith.png',
                  'https://i.postimg.cc/3rBxMwmj/james-Corner.png'
                ]),
                Gap(10),
                IconCard(cardType: 'guest', people: 2, imageUrls: [
                  'https://i.postimg.cc/QCXN9LGW/jasper-Sanchez.png',
                  'https://i.postimg.cc/3rBxMwmj/james-Corner.png'
                ]),
              ],
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconCard(cardType: 'req', people: 2, imageUrls: [
                  'https://i.postimg.cc/Fzgf8gm0/anna-House.png',
                  'https://i.postimg.cc/BQnQJGBr/taylor-Wang.png'
                ]),
                Gap(10),
                IconCard(cardType: 'his', people: 0),
              ],
            )
          ],
        ),
      ),
    );
  }
}
