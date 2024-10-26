import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_setting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
// import 'dart:async';
// import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

class LockScan extends StatelessWidget {
  final String? option;

  const LockScan({super.key, this.option});


  // Future<void> _handleNfcScan(BuildContext context) async {
  //   // Start the NFC scan with a 5-second delay
  //   await Future.delayed(Duration(seconds: 5));

  //   try {
  //     // Start NFC reading
  //     await FlutterNfcKit.poll();

  //     // Simulate some processing time or conditions for success
  //     await Future.delayed(Duration(seconds: 2));

  //     // Successfully read, stop the session
  //     await FlutterNfcKit.finish();

  //     // Navigate to the 'Lock Setting' page
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => LockSetting(),
  //       ),
  //     );
  //   } catch (e) {
  //     // Handle errors, e.g., user canceled, etc.
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size = MediaQuery.of(context).size;
    double outerCircleSize = size.width * 0.8; // 80% of screen width
    double innerCircleSize = size.width * 0.55;

    return Background(
      appBar: AppBar(
        title: MainHeaderLabel(label: 'Scan Your Lock'),
      ),
      child: Center(
        child: Column(children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: outerCircleSize,
                height: outerCircleSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 34, 51, 102)),
              ),
              Container(
                width: innerCircleSize,
                height: innerCircleSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 68, 102, 153)),
              ),
              SvgPicture.asset('assets/svg/scan.svg',
                  semanticsLabel: 'Phone Scan', height: 400),
            ],
          ),
          SizedBox(height: responsive.heightScale(75)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset('assets/svg/nfc.svg',
                  semanticsLabel: 'Phone Scan', height: responsive.heightScale(20)),
              Gap(10),
              Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubLabel(
                      label: 'Connect via NFC',
                      isBold: true,
                    ),
                    SmallLabel(
                      label: 'Hold your phone near to the lock, using NFC',
                      color: Colors.grey[400]),
                    SmallLabel(
                      label: 'phone will automatically connect to the lock.',
                      color: Colors.grey[400],
                    )
                  ])
            ],
          ),
          Spacer(),
          Align(
              alignment: Alignment.bottomCenter,
              child: Button(
                  onTap: () {
                    // _handleNfcScan(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LockSetting(
                          appBarTitle: option == 'register' ? 'Create New Lock' : 'Set Up Lock',
                          option: option,
                        ),
                      ),
                    );
                  },
                  label: 'Scan'))
        ]),
      ),
    );
  }
}
