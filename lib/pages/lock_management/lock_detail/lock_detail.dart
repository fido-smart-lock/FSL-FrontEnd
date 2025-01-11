import 'package:fido_smart_lock/component/background/background_lock_detail.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/card/lock_detail_admin_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/lock_detail_icon_card.dart';
import 'package:fido_smart_lock/component/security_status.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/history_view.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/role_setting_main.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';

class LockDetail extends StatefulWidget {
  final String lockId;

  const LockDetail({
    super.key,
    required this.lockId,
  });

  @override
  State<LockDetail> createState() => _LockDetailState();
}

class _LockDetailState extends State<LockDetail> {
  String? lockLocation = '';
  String? lockName = '';
  String? lockImage = '';
  bool? isAdmin = false;
  String? securityStatus = '';
  List<Map<String, dynamic>>? dataList = [];

  @override
  void initState() {
    super.initState();
    fetchUserLockDetail();
  }

  Future<void> fetchUserLockDetail() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/lockDetail/${widget.lockId}/$userId';

      try {
        var data = await getJsonData(apiUri: apiUri);
        debugPrint('Data: $data');
        setState(() {
          lockLocation = data['lockLocation'];
          lockName = data['lockName'];
          lockImage = data['lockImage'];
          isAdmin = data['isAdmin'];
          securityStatus = data['securityStatus'];
          dataList = List<Map<String, dynamic>>.from(data['dataList']);
        });
      } catch (e) {
        debugPrint('Error: $e');
      }
    } else {
      debugPrint('User ID not found in secure storage.');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> adminImages = dataList
        ?.where((user) => user['role'] == 'admin')
        .map<String>((user) => user['userImage'] as String? ?? '')
        .toList() ??
    [];

    int adminCount = adminImages.length;

    List<String> memberImages = dataList
            ?.where((user) => user['role'] == 'member')
            .map<String>((user) => user['userImage'] as String? ?? '')
            .toList() ??
        [];

    int memberCount = memberImages.length;

    List<String> guestImages = dataList
            ?.where((user) => user['role'] == 'guest')
            .map<String>((user) => user['userImage'] as String? ?? '')
            .toList() ??
        [];

    int guestCount = guestImages.length;

    List<String> reqImages = dataList
            ?.where((user) => user['role'] == 'req')
            .map<String>((user) => user['userImage'] as String? ?? '')
            .toList() ??
        [];

    int reqCount = reqImages.length;

    return BackgroundLockDetail(
      imageUrl: lockImage,
      appBar: AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              size: 'xxl',
              label: lockName!,
              isShadow: true,
            ),
            Label(
              size: 'l',
              label: lockLocation!,
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
                      lockId: widget.lockId,
                      appBarTitle: 'Lock Setting',
                      img: lockImage,
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
                SecurityStatus(status: securityStatus!),
                ScanButton(
                  lockId: widget.lockId,
                  lockName: lockName!,
                  lockLocation: lockLocation!,
                )
              ],
            ),
            Gap(10),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      AdminCard(
                        isManageable: isAdmin!,
                        people: adminCount,
                        imageUrls: adminImages,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminAndMemberSettingMain(
                                lockLocation: lockLocation!,
                                lockName: lockName!,
                                isAdmin: isAdmin!,
                                lockId: widget.lockId,
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
                            people: memberCount,
                            imageUrls: memberImages,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AdminAndMemberSettingMain(
                                    lockLocation: lockLocation!,
                                    lockName: lockName!,
                                    isAdmin: isAdmin!,
                                    lockId: widget.lockId,
                                    role: 'member',
                                  ),
                                ),
                              );
                            },
                          ),
                          IconCard(
                            cardType: 'guest',
                            people: guestCount,
                            imageUrls: guestImages,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => GuestSettingMain(
                                    lockLocation: lockLocation!,
                                    lockName: lockName!,
                                    isAdmin: isAdmin!,
                                    lockId: widget.lockId,
                                    role: 'guest',
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
                          if (isAdmin!)
                            IconCard(
                              cardType: 'req',
                              people: reqCount,
                              imageUrls: reqImages,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestSettingMain(
                                      lockLocation: lockLocation!,
                                      lockName: lockName!,
                                      lockId: widget.lockId,
                                      role: 'req',
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
                                  builder: (context) => HistoryView(
                                      lockId: widget.lockId,
                                      lockName: lockName!,
                                      lockLocation: lockLocation!),
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
