// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/capsule.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/lock_card.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/modal/confirmation_modal.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/image.dart';
import 'package:fido_smart_lock/pages/home.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_location_customize.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

class LockSetting extends StatefulWidget {
  const LockSetting(
      {super.key,
      required this.appBarTitle,
      this.option,
      this.img,
      this.name,
      this.location,
      this.isSettingFromLock = false,
      required this.lockId,
      this.userRole = ''});

  final String appBarTitle;
  final String? option;
  final String? img;
  final String? name;
  final String? location;
  final bool isSettingFromLock;
  final String lockId;
  final String userRole;

  @override
  _LockSettingState createState() => _LockSettingState();
}

class _LockSettingState extends State<LockSetting> {
  late TextEditingController _nameController;
  String? _selectedLocation;
  bool _isNameValid = true;
  bool _isLocationValid = true;
  List<String>? lockLocationList = [];
  bool isDataLoaded = false;
  File? _selectedImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    fetchUserLockLocation();
    // Initialize the controller with the passed name or leave it empty
    _nameController = TextEditingController(
        text: widget.name?.isNotEmpty == true ? widget.name : "");
    _selectedLocation = widget.location;

    // Listener to reset name validity when user starts typing
    _nameController.addListener(() {
      setState(() {
        _isNameValid = _nameController.text
            .trim()
            .isNotEmpty; // Reset to valid when typing
      });
    });
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

  Future<void> updateLockSetting() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      Map<String, dynamic> requestBody = {
        'userId': userId,
        'lockId': widget.lockId,
        'newLockName': _nameController.text.trim(),
        'newLockLocation': _selectedLocation,
        'newLockImage': _imageUrl,
      };

      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/editLockDetail';

      try {
        // ignore: unused_local_variable
        var response = await putJsonData(apiUri: apiUri, body: requestBody);

        // Check response and handle success
        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Great!',
            message: 'Lock detail has been update successfully!',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
        Navigator.pop(context, true);
      } catch (e) {
        RegExp regExp = RegExp(r'(\d{3})'); // Matches three digits (e.g., 409)
        String? statusCode = regExp.stringMatch(e.toString());

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Oh no!',
            message:
                'Something went wrong, please try again. status code $statusCode',
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

  Future<void> postNewLock() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      Map<String, dynamic> requestBody = {
        "userId": userId,
        "lockId": widget.lockId,
        "lockName": _nameController.text.trim(),
        "lockLocation": _selectedLocation,
        "lockImage": _imageUrl
      };

      String apiUri = 'https://fsl-1080584581311.us-central1.run.app/newLock';

      try {
        // ignore: unused_local_variable
        var response = await postJsonData(apiUri: apiUri, body: requestBody);

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Great!',
            message: 'Lock has been create successfully.',
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
            message:
                'Something went wrong, please try again. status code $statusCode',
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

  Future<void> acceptInvitation() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    Map<String, dynamic> requestBody = {
      "userId": userId,
      "lockId": widget.lockId,
      "userRole": widget.userRole,
      "lockName": _nameController.text.trim(),
      "lockLocation": _selectedLocation,
      "lockImage": _imageUrl
    };

    debugPrint('accept invitation request body: $requestBody');

    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/acceptInvitation';

    try {
      var response = await putJsonData(apiUri: apiUri, body: requestBody);
      debugPrint('accept invitation: $response');
    } catch (e) {
      debugPrint('Error accepting invitation: $e');
    }
  }

  Future<void> deleteLock() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/deleteLockFromUser';

    Map<String, dynamic> requestBody = {
      "userId": userId,
      "lockId": widget.lockId,
    };

    try {
      final response = await deleteJsonDataWithRequestBody(
          apiUri: apiUri, body: requestBody);
      debugPrint('Delete successful: $response');
    } catch (e) {
      debugPrint('Error deleting lock: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    // Step 1: Pick image from gallery
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (returnedImage == null) return;

    setState(() {
      _selectedImage = File(returnedImage.path); // Store the selected image
    });

    // Step 2: Upload image to Cloudinary
    String? uploadedUrl = await uploadImageToCloudinary(_selectedImage!);

    if (uploadedUrl != null) {
      setState(() {
        _imageUrl = uploadedUrl; // Store the uploaded image URL
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onLocationSelected(String location) {
    setState(() {
      _selectedLocation = location;
      _isLocationValid =
          true; // Reset validation when a valid selection is made
    });
  }

  Future<void> _validateAndSave() async {
    setState(() {
      // Check if name is empty and if location is selected
      _isNameValid = _nameController.text.trim().isNotEmpty;
      _isLocationValid = _selectedLocation != null;
    });

    // Only proceed if both name and location are valid
    if (_isNameValid && _isLocationValid) {
      if (widget.option == 'request') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RequestAccess(
              lockId: widget.lockId,
              lockName: _nameController.text.trim(),
              lockLocation: _selectedLocation!,
              lockImage: _imageUrl ?? '',
            ),
          ),
        );
      } else if (widget.isSettingFromLock) {
        await updateLockSetting();
      } else if (widget.option == 'accept') {
        await acceptInvitation();
        Navigator.pushReplacement(
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
            message: 'You have accepted the invitation!',
            contentType: ContentType.success,
          ),
        );

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } else {
        await postNewLock();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home(initialIndex: 0),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Background(
        appBar: AppBar(
          centerTitle: true,
          title: Label(size: 'xxl', label: widget.appBarTitle),
          actions: [
            if (widget.isSettingFromLock)
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    showConfirmationModal(context,
                        message: 'Are you sure you want to delete this lock?',
                        isCanNotUndone: true, onProceed: () async {
                      await deleteLock();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(initialIndex: 0),
                        ),
                      );
                    });
                  },
                  child: Icon(
                    CupertinoIcons.trash,
                    color: Colors.red,
                  ),
                ),
              )
          ],
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: 1,
                  itemBuilder: (context, index) {
                    return IntrinsicHeight(
                      child: Column(
                        children: [
                          LockCard(
                            isBadged: true,
                            img: _imageUrl ?? widget.img,
                            name: _nameController.text.isNotEmpty
                                ? _nameController.text
                                : "New Lock",
                            onTap: () {
                              _pickImageFromGallery();
                            },
                          ),
                          const Gap(20),
                          CustomTextField(
                            controller: _nameController,
                            maxLength: 20,
                            labelText: 'Enter lock name',
                            labelColor:
                                _isNameValid ? Colors.white : Colors.red,
                            mode: 'maxLength',
                            isValid: _isNameValid,
                          ),
                          const Gap(20),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Label(
                                  size: 'm',
                                  label: 'Lock Location',
                                  color: _isLocationValid
                                      ? Colors.white
                                      : Colors.red,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            LockLocationCustomize(),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    children: const <Widget>[
                                      Icon(CupertinoIcons.pen,
                                          color: Colors.grey),
                                      Label(
                                          size: 's',
                                          label: 'Customize',
                                          color: Colors.grey),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Gap(10),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: lockLocationList!.map((location) {
                                  return LocationCapsule(
                                    location: location,
                                    isSelected: _selectedLocation == location,
                                    onTap: () => _onLocationSelected(location),
                                  );
                                }).toList()),
                          ),
                        ],
                      ),
                    );
                  }),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Button(
                  onTap: _validateAndSave,
                  label: 'Save Change',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
