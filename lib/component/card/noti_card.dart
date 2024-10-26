import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/datetime.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotiCard extends StatelessWidget {
  NotiCard({
    super.key,
    required this.dateTime,
    required this.mode,
    this.number = 1,
    this.subMode = '',
    this.lockName = '',
    this.lockLocation = '',
    this.role = '',
    this.name = '',
  });

  final String mode;
  final String subMode;
  final String dateTime;
  final int number;
  final String lockName;
  final String lockLocation;
  final String role;
  final String name;

  String _getMainTextLabel() {
    if (mode == 'warning') {
      return 'Found $number risk ${addPlural(number, 'attempt')}';
    } else if (mode == 'req') {
      return '$number ${addPlural(number, 'request')} pending';
    } else if (mode == 'connect') {
      return 'Connected successfully';
    } else if (mode == 'other') {
      if ((subMode == 'sent') || (subMode == 'accepted')) {
        return '${addLabelPossessive(lockName)} request is $subMode';
      } else if (subMode == 'invite') {
        return '$lockName $role invitation';
      }
    }
    return '';
  }

  final modeConfig = {
    'warning': {
      'icon': CupertinoIcons.exclamationmark_shield,
      'color': Colors.red,
      'LabelCapsuleButtonColor': null,
      'labelText': 'Ignore All',
      'labelCapsuleButton': 'View All',
      'onTapText': () {},
      'onTapCapsuleButton': () {}
    },
    'req': {
      'icon': CupertinoIcons.bell,
      'color': Colors.amber,
      'LabelCapsuleButtonColor': Colors.grey[850],
      'labelText': 'View All',
      'labelCapsuleButton': 'Accept All',
      'onTapText': () {},
      'onTapCapsuleButton': () {}
    },
    'connect': {
      'icon': CupertinoIcons.check_mark_circled,
      'color': Colors.green,
      'LabelCapsuleButtonColor': null,
      'labelText': 'View More',
      'labelCapsuleButton': '',
      'onTapText': () {},
      'onTapCapsuleButton': () {}
    },
    'other': {
      'icon': CupertinoIcons.ellipses_bubble,
      'color': Colors.lightBlueAccent,
      'LabelCapsuleButtonColor': Colors.grey[850],
      'labelText': 'Learn More',
      'labelCapsuleButton': 'Accept',
      'onTapText': () {},
      'onTapCapsuleButton': () {}
    }
  };

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final config = modeConfig[mode] ??
        {
          'icon': CupertinoIcons.question_circle,
          'color': Colors.grey,
          'LabelCapsuleButtonColor': null,
          'labelText': '',
          'labelCapsuleButton': '',
          'onTapText': () {},
          'onTapCapsuleButton': () {}
        };

    final icon = config['icon'] as IconData;
    final color = config['color'] as Color;
    final labelText = config['labelText'] as String;
    final labelCapsuleButton = config['labelCapsuleButton'] as String;
    final onTapText = config['onTapText'] as VoidCallback;
    final onTapCapsuleButton = config['onTapCapsuleButton'] as VoidCallback;
    final LabelCapsuleButtonColor = config['LabelCapsuleButtonColor'] as Color? ?? Colors.white;
    const subColor = Colors.grey;

    return Container(
      padding: EdgeInsets.fromLTRB(15,15,20,20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: SmallLabel(
                label: timeDifference(dateTime),
                color: subColor,
              )),
          SizedBox(
            height: responsive.heightScale(5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              SizedBox(width: responsive.widthScale(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubLabel(
                    label: _getMainTextLabel(),
                    isBold: true,
                  ),
                  if ((mode != 'other') ||
                      ((mode == 'other') && (subMode != 'invite')))
                    SmallLabel(
                      label: 'location $lockLocation: $lockName',
                      color: subColor,
                    ),
                  if ((mode == 'req') || (mode == 'connect'))
                    SmallLabel(
                      label: 'by $name',
                      color: subColor,
                    ),
                  if ((mode == 'other') && (subMode == 'sent'))
                    SmallLabel(
                      label: 'waiting for admin to accept request',
                      color: subColor,
                    ),
                  if ((mode == 'other') && (subMode == 'accepted'))
                    SmallLabel(
                      label: 'this lock will be added to your list',
                      color: subColor,
                    ),
                  if ((mode == 'other') && (subMode == 'invite'))
                    SmallLabel(
                      label: 'invited by $name',
                      color: subColor,
                    ),
                ],
              ),
            ],
          ),
          if (((mode == 'other') && (subMode == 'invite')) ||
              (mode == 'req') || (mode == 'warning'))
            Column(
              children: [
                SizedBox(
                  height: responsive.heightScale(10),
                ),
                DoubleButton(
                  labelText: labelText,
                  labelCapsuleButton: labelCapsuleButton,
                  labelCapsuleButtonColor: LabelCapsuleButtonColor,
                  buttonColor: color,
                  onTapText: onTapText,
                  onTapCapsuleButton: onTapCapsuleButton,
                ),
              ],
            ),
          if (mode == 'connect')
            Column(
              children: [
                SizedBox(
                  height: responsive.heightScale(10),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: onTapText,
                    child: SmallLabel(
                      label: labelText,
                      color: color,
                    ),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
