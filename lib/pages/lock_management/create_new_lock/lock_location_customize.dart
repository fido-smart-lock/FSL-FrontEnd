import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/modal/confirmation_modal.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_location_create.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';

class LockLocationCustomize extends StatefulWidget {
  const LockLocationCustomize({super.key});

  @override
  State<LockLocationCustomize> createState() => _LockLocationCustomizeState();
}

class _LockLocationCustomizeState extends State<LockLocationCustomize> {
  List<String>? lockLocationList = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchUserLockLocation();
  }

  Future<void> fetchUserLockLocation() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/lockLocation/user/$userId';

      try {
        var dataLockLocation = await getJsonData(apiUri: apiUri);
        setState(() {
          lockLocationList = List<String>.from(dataLockLocation['dataList']);
          isDataLoaded = true;
        });
      } catch (e) {
        debugPrint('Error: $e');
        setState(() {
          isDataLoaded = false;
        });
      }
    } else {
      setState(() {
        isDataLoaded = false;
      });
    }
  }

  Future<void> deleteLockLocation(String lockLocation) async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/deleteLockLocation';

    Map<String, dynamic> requestBody = {
      "userId": userId,
      "lockLocation": lockLocation
    };

    try {
      await deleteJsonDataWithRequestBody(apiUri: apiUri, body: requestBody);
      await fetchUserLockLocation();
    } catch (e) {
      String errorMessage;
      RegExp regExp = RegExp(r'(\d{3})'); // Matches three digits (e.g., 409)
      String? statusCode = regExp.stringMatch(e.toString());

      if (statusCode == '409') {
        errorMessage = 'Unable to delete the location as it is in use.';
      } else {
        errorMessage =
            'Something went wrong, please try again. status code $statusCode';
      }

      // Show the mapped error message in the SnackBar
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Oh no!',
          message: errorMessage,
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
    return Background(
      appBar: AppBar(centerTitle: true, title: Label(size: 'xxl', label: '')),
      disabledTopPadding: true,
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Label(
                  size: 'xl',
                  label: 'Customize Location',
                  color: Colors.white,
                ),
              ],
            ),
          ),
          const Gap(10),
          Expanded(
              // Added here
              child: ListView.separated(
            itemCount: lockLocationList!.length,
            itemBuilder: (context, index) {
              final location = lockLocationList![index];
              return Padding(
                padding: const EdgeInsets.only(
                    bottom: 10.0, top: 10.0, right: 20.0, left: 15.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Label(
                          label: location,
                          size: 'l',
                        ),
                        GestureDetector(
                          onTap: () async {
                            showConfirmationModal(
                              context,
                              message:
                                  'Are you sure you want to delete $location?',
                              isCanNotUndone: true,
                              onProceed: () async {
                                await deleteLockLocation(location);
                              },
                            );
                          },
                          child: Icon(
                            CupertinoIcons.trash,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 1.0,
              height: 20.0, // Adjust height between items if needed
            ),
          )),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Button(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LockLocationCreate()),
                ).then((value) {
                  fetchUserLockLocation();
                });
              },
              label: 'Create New Location',
            ),
          ),
        ],
      ),
    );
  }
}
