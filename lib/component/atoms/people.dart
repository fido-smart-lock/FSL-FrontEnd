import 'package:fido_smart_lock/component/atoms/button.dart';
import 'package:fido_smart_lock/component/atoms/label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:gap/gap.dart';

class Person extends StatelessWidget {
  final String? img;
  final String name;
  final String? role;
  final String? button;

  const Person({
    super.key,
    this.img,
    required this.name,
    this.role,
    this.button,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, right: 20, top: 13, bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blueGrey[900], // Include color within BoxDecoration
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              ProfilePicture(
                name: name, // Use the name passed to the widget
                radius: 29,
                fontsize: 21,
                img: img, // Use the img passed to the widget
              ),
              const Gap(13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    label: name,
                    isBold: true,
                  ),
                  if (role != null) SubLabel(label: role!, color: Colors.grey,)
                ],
              ),
            ],
          ),
          if (button == 'remove')
            CapsuleButton(
              label: 'Remove',
            )
          else if (button == 'invite')
            CapsuleButton(
              label: 'Invite',
            )
        ],
      ),
    );
  }
}
