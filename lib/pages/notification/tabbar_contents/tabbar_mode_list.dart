// mode_config.dart
import 'package:fido_smart_lock/component/modal/confirmation_modal.dart';
import 'package:fido_smart_lock/component/modal/confirmation_with_date_time_modal.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_setting.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/history_view.dart';
import 'package:fido_smart_lock/pages/lock_management/role_setting/role_setting_main.dart';
import 'package:fido_smart_lock/pages/notification/warning_view/warning_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Map<String, dynamic> getModeConfig(BuildContext context,
    {String name = '',
    String role = '',
    String lockName = '',
    String lockLocation = '',
    String lockId = '',
    String notiId = '',
    Function(String lockId)? onDeleteAllNotification,
    Function(String lockId)? onDeclineInvitation,
    Function(String lockId, String expireDatetime)? onAcceptAllRequest}) {
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
          onProceed: () async {
            onDeleteAllNotification!(lockId);
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
              lockId: lockId,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestSettingMain(
                lockId: lockId,
                role: role,
                lockName: lockName,
                lockLocation: lockLocation),
          ),
        );
      },
      'onTapCapsuleButton': () {
        showConfirmationWithDateTimeModal(
          context,
          message: 'Do you want to accept all request to unlock $lockName?',
          onProceed: () async {
            String expireDatetime = DateTime.now().toIso8601String();

            if (onAcceptAllRequest != null) {
              await onAcceptAllRequest(lockId, expireDatetime);
            }
          },
        );
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
              lockLocation: lockLocation,
              lockName: lockName,
              lockId: lockId,
            ),
          ),
        );
      },
      'onTapCapsuleButton': () {},
    },
    'other': {
      'icon': CupertinoIcons.ellipses_bubble,
      'color': Colors.lightBlueAccent,
      'LabelCapsuleButtonColor': Colors.grey[900],
      'labelText': 'Decline',
      'labelCapsuleButton': 'Accept',
      'onTapText': () async {
        onDeclineInvitation!(notiId);
      },
      'onTapCapsuleButton': () {
        showConfirmationModal(
          context,
          message:
              'Do you want to accept\n$name invitation as a ${capitalizeFirstLetter(role)} of $lockName?',
          onProceed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LockSetting(
                  lockId: lockId,
                  appBarTitle: 'Set up lock',
                  userRole: role,
                  option: 'accept',
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
