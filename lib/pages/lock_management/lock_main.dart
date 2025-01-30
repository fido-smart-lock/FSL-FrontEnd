import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/dropdown/dropdown_capsule.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/lock_card.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_detail/lock_detail.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';

class LockMain extends StatefulWidget {
  const LockMain({super.key});

  @override
  State<LockMain> createState() => _LockMainState();
}

class _LockMainState extends State<LockMain> {
  List<String>? dropdownItems = [];
  List<Map<String, dynamic>>? lockList = []; // <-- Correct type
  String? userName = '';
  String? userImage = '';
  String? lockLocation = '';
  bool isLoading = true;
  String? selectedLocation; // <-- Track selected dropdown value

  @override
  void initState() {
    super.initState();
    fetchUserLockLocation();
  }

  Future<void> fetchUserLockLocation() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    debugPrint('in app: $userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/lockLocation/user/$userId';

      try {
        var dataLockLocation = await getJsonData(apiUri: apiUri);
        List<String> items = List<String>.from(dataLockLocation['dataList']);
        debugPrint('location $items');
        setState(() {
          dropdownItems = items;
          selectedLocation =
              items.isNotEmpty ? items[0] : null; // <-- Default selection
          isLoading = false;
        });
        fetchUserLockList(); // Ensure locks are fetched after setting location
      } catch (e) {
        debugPrint('Error: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchUserLockList() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    debugPrint('in fetchUserLockList: $userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/lockList/$userId/$selectedLocation';

      try {
        var dataLockList = await getJsonData(apiUri: apiUri);

        setState(() {
          lockLocation = dataLockList['lockLocation'];
          userName = dataLockList['userName'];
          userImage = dataLockList['userImage'];
          lockList = List<Map<String, dynamic>>.from(dataLockList['dataList']);
          debugPrint('locklist: $lockList');
        });
      } catch (e) {
        debugPrint('Error: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      debugPrint('User ID not found in secure storage.');
      setState(() {
        isLoading = false;
      });
    }
  }

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
                backgroundImage: NetworkImage(userImage ?? ''),
              ),
              isLoading
                  ? const CircularProgressIndicator()
                  : dropdownItems!.isEmpty
                      ? SizedBox(width: 50,)
                      : DropdownCapsule(
                          items: dropdownItems ?? [],
                          selectedItem: selectedLocation,
                          onSelected: (value) {
                            setState(() {
                              selectedLocation = value;
                              fetchUserLockList();
                            });
                          },
                        ),
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
                      size: 'xxl',
                      label: 'Good Day',
                      name: userName,
                      isBold: true),
                  const Label(size: 'l', label: 'Manage Your Locks'),
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
                ...lockList!.map((item) {
                  return LockCard(
                    img: item['lockImage'],
                    name: item['lockName']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LockDetail(
                              lockId: item['lockId']!), // Pass selected value
                        ),
                      );
                    },
                  );
                }),
                AddLockCard(onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LockScan(),
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
