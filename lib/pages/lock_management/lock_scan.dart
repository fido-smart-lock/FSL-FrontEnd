// ignore_for_file: use_build_context_synchronously
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/nfc.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_scan_pass.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_setting.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LockScan extends StatefulWidget {
  final String? option;
  final String? lockId;
  final String lockName;
  final String lockLocation;

  const LockScan(
      {super.key,
      this.option,
      this.lockName = '',
      this.lockLocation = '',
      this.lockId});

  @override
  State<LockScan> createState() => _LockScanState();
}

class _LockScanState extends State<LockScan> {
  bool? isInDatabase;

  Future<void> checkExistingLock(String lockId) async {
    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/admin/lock/$lockId';

    try {
      var data = await getJsonData(apiUri: apiUri);
      setState(() {
        isInDatabase = data['isInDatabase'];
      });
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    startNfcScan(); // Start scanning as soon as the page is built
  }

  Future<void> startNfcScan() async {
    try {
      final tagData = await startNFCReading();
      final uid = await extractNfcUid(tagData!);

      if (widget.lockId == uid) {
        if (widget.option == 'inLock') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LockScanPass(
                lockName: widget.lockName,
                lockLocation: widget.lockLocation,
              ),
            ),
          );
        } else if (widget.option == 'inLockFinal') {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      } else if (widget.lockId != uid) {
        
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Oh no!',
            message:
                'Lock ID does not match, please try again',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);

      } else {
        await checkExistingLock(uid);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LockSetting(
              lockId: uid,
              appBarTitle:
                  isInDatabase == false ? 'Create New Lock' : 'Set up lock',
              option: isInDatabase == true ? 'request' : 'register',
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Oh no!',
            message:
                'Error scanning NFC tag. Please try again.',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final size = MediaQuery.of(context).size;
    double outerCircleSize = size.width * 0.8; // 80% of screen width
    double innerCircleSize = size.width * 0.55;

    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: widget.option == 'inLock'
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Label(
                    size: 'xxl',
                    label: widget.lockName,
                    isShadow: true,
                  ),
                  Label(
                    size: 'l',
                    label: widget.lockLocation,
                    color: Colors.grey.shade300,
                    isShadow: true,
                  ),
                ],
              )
            : Label(size: 'xxl', label: 'Scan Your Lock'),
      ),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      semanticsLabel: 'Phone Scan',
                      height: responsive.heightScale(400)),
                ],
              ),
              SizedBox(height: responsive.heightScale(75)),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/svg/nfc.svg',
                      semanticsLabel: 'Phone Scan',
                      height: responsive.heightScale(20)),
                  Gap(10),
                  Flexible(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            size: 's',
                            label: 'Connect via NFC',
                            isBold: true,
                          ),
                          Label(
                              size: 'xs',
                              label:
                                  'Hold your phone near to the lock, using NFC phone will automatically connect to the lock.',
                              color: Colors.grey[400]),
                        ]),
                  )
                ],
              ),
              // Spacer(),
              // Align(
              //     alignment: Alignment.bottomCenter,
              //     child: Button(
              //         onTap: () async {
              //           final tagData = await startNFCReading();
              //           final uid = await extractNfcUid(tagData!);

              //           if (widget.lockId == uid) {
              //             if (widget.option == 'inLock') {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => LockScanPass(
              //                     lockName: widget.lockName,
              //                     lockLocation: widget.lockLocation,
              //                   ),
              //                 ),
              //               );
              //             } else if (widget.option == 'inLockFinal') {
              //               Navigator.popUntil(context, ModalRoute.withName('/'));
              //             }
              //           } else if (widget.lockId != uid) {
              //             ScaffoldMessenger.of(context).showSnackBar(
              //               SnackBar(
              //                 content:
              //                     Text('Lock ID does not match, please try again'),
              //                 duration: const Duration(seconds: 2),
              //               ),
              //             );
              //           } else {
              //             await checkExistingLock(uid);
              //             Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => LockSetting(
              //                   lockId: uid,
              //                   appBarTitle: isInDatabase == false
              //                       ? 'Create New Lock'
              //                       : 'Set up lock',
              //                   option:
              //                       isInDatabase == true ? 'request' : 'register',
              //                 ),
              //               ),
              //             );
              //           }
              //         },
              //         label: 'Scan')),
            ]),
      ),
    );
  }
}
