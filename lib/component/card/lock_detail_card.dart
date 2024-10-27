import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/people.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/cupertino.dart';
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

class IconCard extends StatelessWidget {
  const IconCard({
    super.key,
    required this.people,
    this.imageUrls = const [],
    required this.cardType,
    required this.onTap,
  });

  final int people;
  final List<String> imageUrls;
  final String cardType;
  final VoidCallback onTap;

  String _getSubMessage() {
    if (cardType == 'req') {
      return '$people Pending';
    } else if (cardType == 'his') {
      return 'Track Entry & Exit';
    } else {
      return '$people People';
    }
  }

  static const cardConfig = {
    'member': {
      'icon': CupertinoIcons.person_crop_circle_badge_checkmark,
      'label': 'Member',
    },
    'guest': {
      'icon': CupertinoIcons.tickets,
      'label': 'Invited Guest',
    },
    'req': {
      'icon': CupertinoIcons.bell,
      'label': 'Request',
    },
    'his': {
      'icon': CupertinoIcons.clock,
      'label': 'History',
    },
  };

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final config = cardConfig[cardType] ??
        {
          'icon': CupertinoIcons.question_circle,
          'label': 'N/A',
        };

    final icon = config['icon'] as IconData;
    final label = config['label'] as String;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: responsive.widthScale(150),
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(13.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30),
            SizedBox(
              width: responsive.widthScale(5),
              height: responsive.heightScale(5),
            ),
            Label(size: 'm', label: label, isBold: true),
            const Gap(5),
            Label(size: 'xs', label: _getSubMessage()),
            const Gap(10),
            // Conditionally display PeopleMoreThanTwo only if cardType is not 'his'
            if (cardType != 'his')
              PeopleMoreThanTwo(
                  imageUrls: imageUrls // Pass people value only if shown
                  ),
          ],
        ),
      ),
    );
  }
}
