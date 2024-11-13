import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/pages/user_settings/support/faq.dart';
import 'package:fido_smart_lock/pages/user_settings/support/support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SecurityStatus extends StatelessWidget {
  const SecurityStatus({super.key, required this.status});

  final String status;

  // Map of status values to display names.
  static const statusList = {
    'secure': 'Secure',
    'warning': 'Warning',
    'risk': 'In mature risk',
  };

  // Map of status values to icon and color.
  static const statusConfig = {
    'secure': {
      'icon': CupertinoIcons.lock_shield,
      'color': Colors.green,
    },
    'warning': {
      'icon': CupertinoIcons.exclamationmark_shield,
      'color': Colors.amber,
    },
    'risk': {
      'icon': CupertinoIcons.shield_slash,
      'color': Colors.red,
    },
  };

  @override
  Widget build(BuildContext context) {
    // Use default values if status is not in the map.
    final config = statusConfig[status] ??
        {
          'icon': CupertinoIcons.question_circle,
          'color': Colors.grey,
        };

    final icon = config['icon'] as IconData;
    final color = config['color'] as Color;

    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Faq()),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
              shadows: [
                Shadow(color: Colors.black.withOpacity(0.50), blurRadius: 15.0),
              ],
            ),
            const SizedBox(width: 5),
            Label(
                size: 'm',
                label: 'Security Status:',
                color: color,
                isShadow: true),
            const SizedBox(width: 5),
            Label(
              size: 'm',
              label: statusList[status] ?? 'Unknown',
              color: color,
              isShadow: true,
            ),
          ],
        ),
      ),
    );
  }
}
