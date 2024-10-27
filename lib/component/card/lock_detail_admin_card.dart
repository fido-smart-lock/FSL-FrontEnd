import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/people.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AdminCard extends StatelessWidget {
  const AdminCard(
      {super.key,
      this.isManageable = false,
      required this.people,
      this.imageUrls = const [],
      required this.onTap});

  final bool isManageable;
  final int people;
  final List<String> imageUrls;
  final VoidCallback onTap;

  String _getAdminMessage() {
    if (isManageable) {
      if (people > 1) {
        return 'You and ${people - 1} others can manage this lock';
      } else {
        return 'Only you can manage this lock';
      }
    } else {
      return '$people ${people == 1 ? 'person' : 'people'} can manage this lock';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.topLeft,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(size: 'm', label: 'Admin', isBold: true),
            Gap(5),
            Label(size: 'xs', label: _getAdminMessage()),
            Gap(10),
            People(imageUrls: imageUrls)
          ],
        ),
      ),
    );
  }
}

