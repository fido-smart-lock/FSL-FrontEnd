import 'dart:convert';

import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/Image.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/userid.dart';
import 'package:fido_smart_lock/pages/log_in/login_main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  bool _isNameValid = true;
  bool _isSurnameValid = true;
  bool _isEmailValid = true;
  late bool _isVerified = false;

  final storage = FlutterSecureStorage();

  File? _selectedImage; // Image file
  String? _imageUrl; // URL after uploading to Cloudinary

  Future<Map<String, dynamic>> _loadProfileData() async {
    final String response =
        await rootBundle.loadString('assets/data/profile_setting.json');
    final Map<String, dynamic> data = json.decode(response);
    return data;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _emailController.dispose();
    super.dispose();
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
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _isVerified = false;

    _loadProfileData().then((data) {
      setState(() {
        _nameController.text = data['name'] ?? '';
        _surnameController.text = data['surname'] ?? '';
        _emailController.text = data['email'] ?? '';
        _isVerified = data['isVerified'] ?? false;
      });
    });

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

      //TODO: Save image URL to database+config the API
      //   // Step 3: Save image URL to database
      //   await saveImageUrlToDatabase(_imageUrl!);
      // } else {
      //   print('Failed to upload image');
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (_nameController.text.isEmpty &&
        _surnameController.text.isEmpty &&
        _emailController.text.isEmpty) {
      // Display a loading indicator until data is loaded
      return const Center(child: CircularProgressIndicator());
    }

    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Label(
          size: 'xxl',
          label: 'Edit Profile',
          isShadow: true,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () async {
                removeUserIdAndUserCode();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginMain(),
                  ),
                );
              },
              child: Icon(
                Icons.logout_rounded,
                size: 30,
                color: Colors.red,
                shadows: <Shadow>[
                  Shadow(
                      color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
                ],
              ),
            ),
          )
        ],
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
                                'https://i.postimg.cc/jdtLgPgX/jonathan-Smith.png',),
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
              onTap: _validateAndSave, // Trigger validation and navigation
              label: 'Save Change',
            ),
          ),
        ],
      ),
    );
  }
}
