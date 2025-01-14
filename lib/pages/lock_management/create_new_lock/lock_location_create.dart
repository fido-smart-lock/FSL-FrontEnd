import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LockLocationCreate extends StatefulWidget {
  const LockLocationCreate({super.key});

  @override
  State<LockLocationCreate> createState() => _LockLocationCreateState();
}

class _LockLocationCreateState extends State<LockLocationCreate> {
  late TextEditingController _locationNameController;
  bool _isLocationNameValid = true;
  List<String>? lockLocationList = [];
  bool isDataLoaded = false;

  @override
  void dispose() {
    _locationNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _locationNameController = TextEditingController();

    // Listener to reset name validity when user starts typing
    _locationNameController.addListener(() {
      setState(() {
        _isLocationNameValid = _locationNameController.text
            .trim()
            .isNotEmpty; // Reset to valid when typing
      });
    });
  }

  Future<void> onCreate() async {
    setState(() {
      _isLocationNameValid = _locationNameController.text.trim().isNotEmpty;
    });

    if (_isLocationNameValid) {
      sendInviteRequest(_locationNameController.text.trim());
    }
  }

  Future<void> sendInviteRequest(String location) async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    try {
      // ignore: unused_local_variable
      final response = await postJsonDataWithoutBody(
          apiUri:
              'https://fsl-1080584581311.us-central1.run.app/lockLocation/$userId/$location');
      Navigator.pop(context, true);
    } catch (e) {
      RegExp regExp = RegExp(r'(\d{3})');
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
  }

  @override
  Widget build(BuildContext context) {
    return Background(
      appBar: AppBar(
          centerTitle: true,
          title: Label(size: 'xxl', label: 'Create New Location')),
      disabledTopPadding: true,
      child: Column(
        children: <Widget>[
          CustomTextField(
            controller: _locationNameController,
            maxLength: 10,
            labelText: 'Enter location name',
            labelColor: _isLocationNameValid ? Colors.white : Colors.red,
            mode: 'maxLength',
            isValid: _isLocationNameValid,
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Button(
              onTap: onCreate,
              label: 'Create New Location',
            ),
          ),
        ],
      ),
    );
  }
}
