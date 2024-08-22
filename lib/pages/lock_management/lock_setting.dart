import 'package:fido_smart_lock/component/atoms/background.dart';
import 'package:fido_smart_lock/component/atoms/button.dart';
import 'package:fido_smart_lock/component/atoms/capsule.dart';
import 'package:fido_smart_lock/component/atoms/label.dart';
import 'package:fido_smart_lock/component/atoms/lock_card.dart';
import 'package:fido_smart_lock/component/atoms/textfield_input.dart';
import 'package:fido_smart_lock/pages/home.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_location_customize.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_main.dart';
import 'package:fido_smart_lock/pages/lock_management/create_new_lock/lock_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LockSetting extends StatefulWidget {
  const LockSetting({super.key, required this.appBarTitle, this.option});

  final String appBarTitle;
  final String? option;

  @override
  _LockSettingState createState() => _LockSettingState();
}

class _LockSettingState extends State<LockSetting> {
  String _lockName = "New Lock";
  String? _selectedLocation;

  static const List<String> lockLocation = [
    "Home",
    "Office",
    "Airbnbbbbb",
  ];

  void _onNameChanged(String newName) {
    setState(() {
      _lockName = newName;
    });
  }

  void _onTap() {
    print('LockCard tapped!');
  }

  void _onLocationSelected(String location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss the keyboard and lose focus
      },
      child: Background(
        appBar: AppBar(
          title: MainHeaderLabel(label: widget.appBarTitle),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                LockCard(
                  isBadged: true,
                  img: null, // Provide an image URL if needed
                  name: _lockName,
                  onTap: _onTap,
                ),
                const Gap(20),
                CustomTextField(
                  maxLength: 20,
                  labelText: 'Enter lock name',
                  onChanged: _onNameChanged,
                ),
                const Gap(20),
                Align(
                  alignment: Alignment.topCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Label(
                        label: 'Lock Location',
                        color: Colors.white,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LockLocationCustomize()),
                          );
                        },
                        child: Row(
                          children: <Widget>[
                            Icon(
                              CupertinoIcons.pen,
                              color: Colors.grey,
                            ),
                            SubLabel(
                              label: 'Customize',
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      )
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
                Gap(300),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Button(
                    onTap: () {
                      if (widget.option == 'request') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RequestAccess(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Home(initialIndex: 0),
                          ),
                        );
                      }
                    },
                    label: 'Save Change',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
