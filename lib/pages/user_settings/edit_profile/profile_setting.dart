import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/Image.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  String? userImage = '';

  late TextEditingController _emailController;
  String? _imageUrl; // URL after uploading to Cloudinary
  bool _isEmailValid = true;
  bool _isNameValid = true;
  bool _isSurnameValid = true;
  late bool _isVerified = false;
  late TextEditingController _nameController;
  File? _selectedImage; // Image file
  late TextEditingController _surnameController;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _isVerified = false;

    fetchUserProfile();

    // Listener to reset name validity when user starts typing
    _nameController.addListener(() {
      setState(() {
        _isNameValid = _nameController.text.trim().isNotEmpty;
      });
    });
    _surnameController.addListener(() {
      setState(() {
        _isSurnameValid = _surnameController.text.trim().isNotEmpty;
      });
    });
    _emailController.addListener(() {
      setState(() {
        _isEmailValid = RegExp(
                r'^[^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*@([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}$')
            .hasMatch(_emailController.text.trim());
      });
    });
  }

  Future<void> updateProfile() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId'); // Retrieve userId

    if (userId != null) {
      // Prepare the request body
      Map<String, dynamic> requestBody = {
        'userId': userId,
        'newEmail': _emailController.text.trim(),
        'newFirstName': _nameController.text.trim(),
        'newLastName': _surnameController.text.trim(),
        'newImage': _imageUrl,
      };

      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/user/editProfile';

      try {
        // ignore: unused_local_variable
        var response = await putJsonData(apiUri: apiUri, body: requestBody);

        final snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Great!',
            message: 'Profile updated successfully!',
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
    }
  }

  Future<void> fetchUserProfile() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    debugPrint('in setting: $userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/userDetail/$userId';

      try {
        var dataProfile = await getJsonData(apiUri: apiUri);
        setState(() {
          _isVerified = dataProfile['isEmailVerified'];
          _nameController.text = dataProfile['userName'];
          _surnameController.text = dataProfile['userSurname'];
          _emailController.text = dataProfile['userEmail'];
          userImage = dataProfile['userImage'];
        });
      } catch (e) {
        debugPrint('Error: $e');
      }
    } else {
      debugPrint('User ID not found in secure storage.');
    }
  }

  void _validateAndSave() {
    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
      _isSurnameValid = _surnameController.text.trim().isNotEmpty;
      _isEmailValid = RegExp(
              r'^[^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*@([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}$')
          .hasMatch(_emailController.text.trim());
    });

    // Only proceed if both name and location are valid
    if (_isNameValid && _isSurnameValid && _isEmailValid) {
      updateProfile();
      fetchUserProfile();
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
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (_nameController.text.isEmpty &&
        _surnameController.text.isEmpty &&
        _emailController.text.isEmpty) {
      // Display a loading indicator until data is loaded
      return Background(
          appBar: AppBar(
              centerTitle: true,
              title: Label(
                size: 'xxl',
                label: 'Edit Profile',
                isShadow: true,
              )),
          child: Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          )));
    }
    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Label(
          size: 'xxl',
          label: 'Edit Profile',
          isShadow: true,
        ),
        
      ),
      child: Column(
        children: [
          SingleChildScrollView(
            // Replace ListView.builder with SingleChildScrollView
            child: Column(
              // Use a Column directly
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _pickImageFromGallery();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(55),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundColor: Colors.blueAccent,
                      child: badges.Badge(
                        badgeContent: Icon(
                          CupertinoIcons.photo,
                          color: Colors.white,
                          size: 23,
                        ),
                        showBadge: true,
                        badgeStyle: badges.BadgeStyle(
                          badgeColor: Colors.blue,
                          padding: EdgeInsets.all(8),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            _imageUrl ??
                                userImage ??
                                '',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: responsive.heightScale(20),
                ),
                Row(
                  children: [
                    Expanded(
                      // Add Expanded or Flexible if needed
                      child: CustomTextField(
                        controller: _nameController,
                        labelText: 'First Name',
                        labelColor: _isNameValid ? Colors.white : Colors.red,
                        isValid: _isNameValid,
                      ),
                    ),
                    SizedBox(
                      width: responsive.heightScale(20),
                    ),
                    Expanded(
                      child: CustomTextField(
                        controller: _surnameController,
                        labelText: 'Last Name',
                        labelColor: _isSurnameValid ? Colors.white : Colors.red,
                        isValid: _isNameValid,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: responsive.heightScale(15),
                ),
                CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  labelColor: _isEmailValid ? Colors.white : Colors.red,
                  mode: 'verified',
                  isValid: _isEmailValid,
                ),
                SizedBox(
                  height: responsive.heightScale(5),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  Label(
                    size: 's',
                    label: _isVerified ? 'verified' : 'send email',
                    color: _isVerified ? Colors.green : Colors.grey,
                  ),
                  SizedBox(
                    width: responsive.widthScale(5),
                  ),
                  Icon(
                    _isVerified
                        ? CupertinoIcons.check_mark_circled
                        : CupertinoIcons.mail,
                    color: _isVerified ? Colors.green : Colors.grey,
                    size: 17,
                  ),
                ])
              ],
            ),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Button(
              onTap: () {
                _validateAndSave(); // Validate inputs
              }, // Trigger validation and navigation
              label: 'Save Change',
            ),
          ),
        ],
      ),
    );
  }
}
