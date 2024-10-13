import 'package:fido_smart_lock/component/atoms/button.dart';
import 'package:fido_smart_lock/component/atoms/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:dotted_border/dotted_border.dart';
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

class People extends StatelessWidget {
  final List<String> imageUrls;

  const People({
    super.key,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Ensure enough space for the avatars
      child: Stack(
        children: imageUrls.asMap().entries.map((entry) {
          int index = entry.key;
          String url = entry.value;

          // Calculate the left position based on the index
          return Positioned(
            left: index * 40.0, // Adjust overlap amount here (reduce the multiplier)
            child: CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(url),
            ),
          );
        }).toList().reversed.toList(), // Reverse the order of the widget list
      ),
    );
  }
} // Ensure you have this package in your pubspec.yaml

class PeopleMoreThanTwo extends StatelessWidget {
  final List<String> imageUrls;

  const PeopleMoreThanTwo({
    super.key,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 135, // Ensure enough space for the avatars
      child: Stack(
        children: [
          // Add the DottedBorder if there are more than 2 image URLs
          if (imageUrls.length > 2) ...[
            Positioned(
              left: 2 * 30.0, // Position this after the two CircleAvatars
              child: DottedBorder(
                borderType: BorderType.RRect,
                dashPattern: [7, 8],
                strokeWidth: 2,
                radius: Radius.circular(25),
                color: Colors.grey,
                child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.transparent,
                  child: Icon(CupertinoIcons.ellipsis, color: Colors.grey, size: 30,),
                ),
              ),
            ),
          ],

          // Show only the first two images if there are more than two
          ...imageUrls.take(2).toList().asMap().entries.map((entry) {
            int index = entry.key;
            String url = entry.value;

            return Positioned(
              left: index * 30.0, // Adjust overlap amount here
              child: CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(url),
              ),
            );
          }).toList().reversed,
        ],
      ),
    );
  }
}
