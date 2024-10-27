import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/datetime.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:fido_smart_lock/pages/notification/tabbar_contents/tabbar_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotiCard extends StatelessWidget {
  const NotiCard({
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

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final config = getModeConfig(
          context,
          name: name,
          role: role,
          lockName: lockName,
          lockLocation: lockLocation
        )[mode] ??
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
    final labelCapsuleButtonColor =
        config['LabelCapsuleButtonColor'] as Color? ?? Colors.white;
    const subColor = Colors.grey;

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 20, 20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
        border: Border.all(color: color),
      ),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerRight,
              child: Label(
                size: 'xs',
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
              Icon(
                icon,
                color: color,
              ),
              SizedBox(width: responsive.widthScale(10)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    size: 's',
                    label: _getMainTextLabel(),
                    isBold: true,
                  ),
                  if ((mode != 'other') ||
                      ((mode == 'other') && (subMode != 'invite')))
                    Label(
                      size: 'xs',
                      label: 'location $lockLocation: $lockName',
                      color: subColor,
                    ),
                  if ((mode == 'req') || (mode == 'connect'))
                    Label(
                      size: 'xs',
                      label: 'by $name',
                      color: subColor,
                    ),
                  if ((mode == 'other') && (subMode == 'sent'))
                    Label(
                      size: 'xs',
                      label: 'waiting for admin to accept request',
                      color: subColor,
                    ),
                  if ((mode == 'other') && (subMode == 'accepted'))
                    Label(
                      size: 'xs',
                      label: 'this lock will be added to your list',
                      color: subColor,
                    ),
                  if ((mode == 'other') && (subMode == 'invite'))
                    Label(
                      size: 'xs',
                      label: 'invited by $name',
                      color: subColor,
                    ),
                ],
              ),
            ],
          ),
          if (((mode == 'other') && (subMode == 'invite')) ||
              (mode == 'req') ||
              (mode == 'warning'))
            Column(
              children: [
                SizedBox(
                  height: responsive.heightScale(10),
                ),
                DoubleButton(
                  labelText: labelText,
                  labelCapsuleButton: labelCapsuleButton,
                  labelCapsuleButtonColor: labelCapsuleButtonColor,
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
                    child: Label(
                      size: 'xs',
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
