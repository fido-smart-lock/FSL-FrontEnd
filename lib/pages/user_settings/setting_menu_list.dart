// mode_config.dart
import 'package:fido_smart_lock/pages/user_settings/edit_profile/profile_setting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> getMenuConfig(
  BuildContext context,
  // {String name = '',
  // String role = '',
  // String lockName = '',
  // String lockLocation = ''}
) {
  return {
    'profile': {
      'icon': CupertinoIcons.person_fill,
      'menuName': 'Edit Profile',
      'description': '',
      'isToggle': false,
      'onTap': () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileSetting(),
          ),
        );
      }
    },
    'security': {
      'icon': Icons.fingerprint_rounded,
      'menuName': 'Security',
      'description': '',
      'isToggle': false,
      'onTap': () {}
    },
    'noti': {
      'icon': Icons.settings_rounded,
      'menuName': 'Notification Setting',
      'description': '',
      'isToggle': false,
      'onTap': () {}
    },
    'support': {
      'icon': Icons.support_rounded,
      'menuName': 'Support',
      'description': '',
      'isToggle': false,
      'onTap': () {}
    },
    'logout': {
      'icon': Icons.logout_rounded,
      'menuName': 'Logout',
      'description': '',
      'isToggle': false,
      'onTap': () {}
    },
    'password': {
      'icon': Icons.password_rounded,
      'menuName': 'Change Password',
      'description': '',
      'isToggle': false,
      'onTap': () {}
    },
    'biometric': {
      'icon': Icons.fingerprint_rounded,
      'menuName': 'Enable Biometrics',
      'description':
          'enable to allow login with\nfingerprint/iris/face recognition',
      'isToggle': true,
      'onTap': () {}
    },
    'hardware': {
      'icon': Icons.memory_rounded,
      'menuName': 'Enable Hardware Keys',
      'description':
          'enable to allow login with\npiece of small USB stick or key fob',
      'isToggle': true,
      'onTap': () {}
    },
    'push': {
      'icon': Icons.notifications_active_rounded,
      'menuName': 'Push Notification',
      'description': '',
      'isToggle': true,
      'onTap': () {}
    },
    'email': {
      'icon': Icons.alternate_email_rounded,
      'menuName': 'Notification via Email',
      'description': '',
      'isToggle': true,
      'onTap': () {}
    },
    'trouble': {
      'icon': Icons.outlined_flag_rounded,
      'menuName': 'Troubleshooting',
      'description': '',
      'isToggle': false,
      'onTap': () {}
    },
    'faq': {
      'icon': CupertinoIcons.question_diamond,
      'menuName': 'FAQ',
      'description': '',
      'isToggle': false,
      'onTap': () {}
    },
  };
}
