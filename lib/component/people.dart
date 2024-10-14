import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
        children: imageUrls
            .asMap()
            .entries
            .map((entry) {
              int index = entry.key;
              String url = entry.value;

              // Calculate the left position based on the index
              return Positioned(
                left: index *
                    40.0, // Adjust overlap amount here (reduce the multiplier)
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(url),
                ),
              );
            })
            .toList()
            .reversed
            .toList(), // Reverse the order of the widget list
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
                  child: Icon(
                    CupertinoIcons.ellipsis,
                    color: Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
          ],

          // Show only the first two images if there are more than two
          ...imageUrls
              .take(2)
              .toList()
              .asMap()
              .entries
              .map((entry) {
                int index = entry.key;
                String url = entry.value;

                return Positioned(
                  left: index * 30.0, // Adjust overlap amount here
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(url),
                  ),
                );
              })
              .toList()
              .reversed,
        ],
      ),
    );
  }
}
