import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/person_card.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
// import 'package:lottie/lottie.dart';

class RequestAccess extends StatefulWidget {
  const RequestAccess({
    super.key,
    this.lockId = '',
    this.lockName = '',
    this.lockLocation = '',
    this.lockImage = '',
  });

  final String lockId;
  final String lockName;
  final String lockLocation;
  final String lockImage;

  @override
  State<RequestAccess> createState() => _RequestAccessState();
}

class _RequestAccessState extends State<RequestAccess> {
  List<Map<String, dynamic>>? dataList = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchLockAdmin();
  }

  Future<void> fetchLockAdmin() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/admin/lock/${widget.lockId}';

      try {
        var data = await getJsonData(apiUri: apiUri);
        setState(() {
          isDataLoaded = true;
          dataList = List<Map<String, dynamic>>.from(data['dataList']);
        });
      } catch (e) {
        setState(() {
          isDataLoaded = true;
          dataList = [];
        });
        debugPrint('Error: $e');
      }
    } else {
      setState(() {
        isDataLoaded = true;
        dataList = [];
      });
      debugPrint('User ID not found in secure storage.');
    }
  }

  Future<void> postNewLockRequest() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      Map<String, dynamic> requestBody = {
        "userId": userId,
        "lockId": widget.lockId,
        "lockName": widget.lockName,
        "lockLocation": widget.lockLocation,
        "lockImage": widget.lockImage,
      };

      String apiUri = 'https://fsl-1080584581311.us-central1.run.app/request';

      try {
        // ignore: unused_local_variable
        var response = await postJsonData(apiUri: apiUri, body: requestBody);
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Great!',
            message: 'Lock detail has been updated successfully!',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        Navigator.pop(context); // Navigate back after success
      } catch (e) {
        RegExp regExp = RegExp(r'(\d{3})'); // Matches three digits (e.g., 409)
        String? statusCode = regExp.stringMatch(e.toString());

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Oh no!',
            message: 'Something went wrong, please try again. status code $statusCode',
            contentType: ContentType.failure,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      }
    } else {
      debugPrint('User ID not found in secure storage.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Label(size: 'xxl', label: 'Request Access'),
      ),
      disabledTopPadding: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            size: 'm',
            label:
                'By proceeding, this request will notify the admin of the lock in the following list',
          ),
          const Gap(20),
          SizedBox(
            height: 550.0, // Set the height of the ListView
            child: ListView.separated(
              itemCount: dataList!.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 15);
              },
              itemBuilder: (BuildContext context, int index) {
                final item = dataList![index];
                return Person(
                  name: item['name']!,
                  img: item['img']!,
                  role: item['role']!,
                  lockName: '',
                );
              },
            ),
          ),
          Gap(20),
          Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Label(
                    size: 's',
                    label:
                        'You can only have an access to the lock as an \'invited guest\' if you want to be a \'member\' please contact the admin of the lock directly.',
                    color: Colors.grey,
                    isCenter: true,
                  ),
                  Gap(15),
                  Button(
                    onTap: () async {
                      await postNewLockRequest();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(initialIndex: 0),
                        ),
                      );
                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Great!',
                          message: 'Request sent successfully!',
                          contentType: ContentType.success,
                        ),
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    },
                    label: 'Proceed',
                    color: Colors.green,
                  )
                ],
              ))
        ],
      ),
    );
  }
}

// class RequestSend extends StatelessWidget {
//   const RequestSend({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Background(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Label(size: 'xxl', label: 'Request Access'),
//         ),
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: Column(
//             children: [
//               Gap(130),
//               Transform.scale(
//                   scale: 2.3,
//                   child: Lottie.network(
//                     'https://lottie.host/47234022-509e-409a-a8c9-e6da53f5ca3b/B1wGjwm0U4.json',
//                   )),
//               Label(size: 'xl', label: 'Request Send!'),
//               Gap(250),
//               Button(
//                   onTap: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const Home(initialIndex: 0),
//                       ),
//                     );
//                   },
//                   label: 'Woohoo!')
//             ],
//           ),
//         ));
//   }
// }
