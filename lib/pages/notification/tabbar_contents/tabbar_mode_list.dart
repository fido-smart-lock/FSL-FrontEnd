// mode_config.dart
import 'package:fido_smart_lock/component/modal/confirmation_modal.dart';
import 'package:fido_smart_lock/component/modal/confirmation_with_date_time_modal.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_setting.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/history_view.dart';
import 'package:fido_smart_lock/pages/notification/warning_view/warning_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> getModeConfig(BuildContext context,
    {String name = '',
    String role = '',
    String lockName = '',
    String lockLocation = ''}) {
  return {
    'warning': {
      'icon': CupertinoIcons.exclamationmark_shield,
      'color': Colors.red,
      'LabelCapsuleButtonColor': null,
      'labelText': 'Ignore All',
      'labelCapsuleButton': 'View All',
      'onTapText': () {
        showConfirmationModal(
          context,
          message:
              'Are you sure you want to ignore all these risks? It can be a serious threat to your security.',
          isCanNotUndone: true,
          onProceed: () {
            Navigator.of(context).pop();
            // Additional actions for "Proceed" go here
          },
        );
      },
      'onTapCapsuleButton': () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WarningView(
              lockLocation: lockLocation,
              lockName: lockName,
            ),
          ),
        );
      },
    },
    'req': {
      'icon': CupertinoIcons.bell,
      'color': Colors.amber,
      'LabelCapsuleButtonColor': Colors.grey[850],
      'labelText': 'View All',
      'labelCapsuleButton': 'Accept All',
      'onTapText': () {
        //TODO: navigate to LockRequest page
      },
      'onTapCapsuleButton': () {
        showConfirmationWithDateTimeModal(context,
            message: 'Do you want to accept all request to unlock $lockName?',
            onProceed: () {
          Navigator.of(context).pop();
          // Additional actions for "Proceed" go here
        });
      },
    },
    'connect': {
      'icon': CupertinoIcons.check_mark_circled,
      'color': Colors.green,
      'LabelCapsuleButtonColor': null,
      'labelText': 'View More',
      'labelCapsuleButton': '',
      'onTapText': () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HistoryView(
              lockId: '4',
            ),
          ),
        );
      },
      'onTapCapsuleButton': () {},
    },
    'other': {
      'icon': CupertinoIcons.ellipses_bubble,
      'color': Colors.lightBlueAccent,
      'LabelCapsuleButtonColor': Colors.grey[850],
      'labelText': 'Decline',
      'labelCapsuleButton': 'Accept',
      'onTapText': () {},
      'onTapCapsuleButton': () {
        showConfirmationModal(
          context,
          message:
              'Do you want to accept\n$name invitation as a ${capitalizeFirstLetter(role)} of $lockName?',
          onProceed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LockSetting(
                  appBarTitle: 'Set up lock',
                ),
              ),
            );
            // Additional actions for "Proceed" go here
          },
        );
      },
    },
  };
}
