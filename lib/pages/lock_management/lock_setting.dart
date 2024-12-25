import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/capsule.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/lock_card.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/pages/home.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_location_customize.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LockSetting extends StatefulWidget {
  const LockSetting(
      {super.key,
      required this.appBarTitle,
      this.option,
      this.img,
      this.name,
      this.location,
      this.isSettingFromLock = false});

  final String appBarTitle;
  final String? option;
  final String? img;
  final String? name;
  final String? location;
  final bool isSettingFromLock;

  @override
  _LockSettingState createState() => _LockSettingState();
}

class _LockSettingState extends State<LockSetting> {
  late TextEditingController _nameController;
  String? _selectedLocation;
  bool _isNameValid = true;
  bool _isLocationValid = true;

  static const List<String> lockLocation = [
    "Home",
    "Office",
    "Airbnbbbbb",
  ];

  @override
  void initState() {
    super.initState();
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

  void _validateAndSave() {
    setState(() {
      // Check if name is empty and if location is selected
      _isNameValid = _nameController.text.trim().isNotEmpty;
      _isLocationValid = _selectedLocation != null;
    });

    // Only proceed if both name and location are valid
    if (_isNameValid && _isLocationValid) {
      if (widget.option == 'request') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestAccess(),
          ),
        );
      } else if (widget.isSettingFromLock) {
        Navigator.pop(context);
      } else {
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
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true, // Prevents unnecessary scrolling issues
                  itemCount: 1, // Replace with the actual number of items
                  itemBuilder: (context, index) {
                    return IntrinsicHeight(
                      child: Column(
                        children: [
                          LockCard(
                            isBadged: true,
                            img: widget.img,
                            name: _nameController.text.isNotEmpty
                                ? _nameController.text
                                : "New Lock", // Display the name from the controller
                            onTap: () => print('LockCard tapped!'),
                          ),
                          const Gap(20),
                          CustomTextField(
                            controller: _nameController,
                            maxLength: 20,
                            labelText: 'Enter lock name',
                            labelColor: _isNameValid
                                ? Colors.white
                                : Colors.red,
                            mode: 'maxLength',
                            isValid: _isNameValid, // Change color based on validation
                          ),
                          const Gap(20),
                          Align(
                            alignment: Alignment.topCenter,
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Label(
                                  size: 'm',
                                  label: 'Lock Location',
                                  color: _isLocationValid
                                      ? Colors.white
                                      : Colors.red, // Change color based on validation
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
                              children: lockLocation.map((location) {
                                return LocationCapsule(
                                  location: location,
                                  isSelected: _selectedLocation == location,
                                  onTap: () => _onLocationSelected(location),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: Button(
                  onTap:
                      _validateAndSave, // Trigger validation and navigation
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
