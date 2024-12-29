import 'package:fido_smart_lock/component/background/background_lock_detail.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/card/lock_detail_admin_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/lock_detail_icon_card.dart';
import 'package:fido_smart_lock/component/security_status.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/history_view.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/role_setting_main.dart';
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
            Label(
              size: 'xxl',
              label: lockName,
              isShadow: true,
            ),
            Label(
              size: 'l',
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
                      location: lockLocation,
                      isSettingFromLock: true,
                    ),
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
              children: [
                SecurityStatus(status: 'warning'),
                ScanButton(
                  lockName: lockName,
                  lockLocation: lockLocation,
                )
              ],
            ),
            Gap(10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true, // Prevents unnecessary scrolling issues
                itemCount: 1, // Replace with the actual number of items
                itemBuilder: (context, index) {
                  return Column(
                    children: [
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
                              builder: (context) => AdminAndMemberSettingMain(
                                lockName: lockName,
                                lockLocation: lockLocation,
                                img: [
                                  'https://i.postimg.cc/jdtLgPgX/jonathan-Smith.png',
                                  'https://i.postimg.cc/85dPzp3S/josephine-Smith.png',
                                ],
                                name: ['Jonathan Smith', 'Josephine Smith'],
                                role: 'admin',
                              ),
                            ),
                          );
                        },
                      ),
                      Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconCard(
                            cardType: 'member',
                            people: 3,
                            imageUrls: [
                              'https://i.postimg.cc/jSC54rWH/jane-Smith.png',
                              'https://i.postimg.cc/SRDScZk1/jacob-Smith.png',
                              'https://i.postimg.cc/3rBxMwmj/james-Corner.png'
                            ],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdminAndMemberSettingMain(
                                    lockName: lockName,
                                    lockLocation: lockLocation,
                                    img: [
                                      'https://i.postimg.cc/jSC54rWH/jane-Smith.png',
                                      'https://i.postimg.cc/SRDScZk1/jacob-Smith.png',
                                      'https://i.postimg.cc/3rBxMwmj/james-Corner.png'
                                    ],
                                    name: [
                                      'Jane Smith',
                                      'Jacob Smith',
                                      'James Corner'
                                    ],
                                    role: 'member',
                                  ),
                                ),
                              );
                            },
                          ),
                          IconCard(
                            cardType: 'guest',
                            people: 2,
                            imageUrls: [
                              'https://i.postimg.cc/QCXN9LGW/jasper-Sanchez.png',
                              'https://i.postimg.cc/3rBxMwmj/james-Corner.png'
                            ],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GuestSettingMain(
                                    lockName: lockName,
                                    lockLocation: lockLocation,
                                    img: [
                                      'https://i.postimg.cc/QCXN9LGW/jasper-Sanchez.png',
                                      'https://i.postimg.cc/3rBxMwmj/james-Corner.png'
                                    ],
                                    name: [
                                      'Jasper Sanchez',
                                      'thisisanamemorethan15'
                                    ],
                                    role: 'guest',
                                    dateTime: [
                                      '2024-09-10T07:54:38',
                                      '2024-10-30T07:54:38'
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      Gap(5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconCard(
                            cardType: 'req',
                            people: 2,
                            imageUrls: [
                              'https://i.postimg.cc/Fzgf8gm0/anna-House.png',
                              'https://i.postimg.cc/BQnQJGBr/taylor-Wang.png'
                            ],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RequestSettingMain(
                                    lockName: lockName,
                                    lockLocation: lockLocation,
                                    img: [
                                      'https://i.postimg.cc/Fzgf8gm0/anna-House.png',
                                      'https://i.postimg.cc/BQnQJGBr/taylor-Wang.png'
                                    ],
                                    name: ['Anna House', 'Taylor Wang'],
                                    dateTime: [
                                      '2024-10-21T07:52:38',
                                      '2024-09-10T07:54:38'
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          IconCard(
                            cardType: 'his',
                            people: 0,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HistoryView(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
