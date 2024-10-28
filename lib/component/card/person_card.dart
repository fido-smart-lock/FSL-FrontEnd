import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/modal/confirmation_modal.dart';
import 'package:fido_smart_lock/component/modal/confirmation_with_date_time_modal.dart';
import 'package:fido_smart_lock/helper/datetime.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Person extends StatelessWidget {
  final String? img;
  final String name;
  final String? role;
  final String? button;
  final String lockName;
  final String? dateTime;

  const Person(
      {super.key,
      this.img,
      required this.name,
      this.role,
      this.button,
      required this.lockName,
      this.dateTime});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, right: 15, top: 13, bottom: 13),
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
              CircleAvatar(
                radius: responsive.radiusScale(23),
                backgroundImage: NetworkImage(img!),
              ),
              SizedBox(
                width: responsive.widthScale(7),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    size: 's',
                    label: truncateWithEllipsis(name, 20),
                    isBold: true,
                  ),
                  if (role != null && role != 'guest')
                    Label(
                      size: 'xs',
                      label: role!,
                      color: Colors.grey,
                    )
                  else if (role == 'guest')
                    Label(
                      size: 'xxs',
                      label: 'Exp: ${dateDotTimeFormat(dateTime!)}',
                      color: Colors.grey,
                    )
                ],
              ),
            ],
          ),
          if (button == 'remove')
            CapsuleButton(
              label: 'Remove',
              onTap: () {
                showConfirmationModal(context,
                    message:
                        'Do you want to remove $name from $role of $lockName lock?',
                    onProceed: () {});
              },
            )
          else if (button == 'invite')
            CapsuleButton(
              label: 'Invite',
              onTap: () {},
            )
        ],
      ),
    );
  }
}

class PersonRequest extends StatelessWidget {
  final String? img;
  final String name;
  final String? role;
  final String lockName;
  final String dateTime;

  const PersonRequest(
      {super.key,
      this.img,
      required this.name,
      this.role,
      required this.lockName,
      required this.dateTime});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15, right: 20, top: 13, bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
        color: Colors.blueGrey[900], // Include color within BoxDecoration
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: responsive.radiusScale(23),
                  backgroundImage: NetworkImage(img!),
                ),
                const Gap(13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      size: 's',
                      label: truncateWithEllipsis(name, 25),
                      isBold: true,
                    ),
                    Label(
                      size: 'xxs',
                      label: 'Request pending ${timeDifference(dateTime)}',
                      color: Colors.grey,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: Navigator.of(context).pop,
                child: Label(
                  size: 'xs',
                  label: 'Decline',
                  color: Colors.red,
                )),
            Gap(20),
            CapsuleButton(
              label: 'Accept',
              buttonColor: Colors.green,
              labelColor: Colors.white,
              onTap: () {
                showConfirmationWithDateTimeModal(context,
                    message:
                        'Do you want to accept $name request to unlock $lockName?',
                    onProceed: () {});
              },
            )
          ],
        )
      ]),
    );
  }
}

class PersonHistoryCard extends StatelessWidget {
  const PersonHistoryCard(
      {super.key,
      required this.name,
      this.img,
      required this.dateTime,
      required this.status});

  final String name;
  final String? img;
  final String dateTime;
  final String status;

  static const iconConfig = {
    'connect': {
      'icon': CupertinoIcons.check_mark_circled,
      'color': Colors.green,
    },
    'req': {
      'icon': CupertinoIcons.bell,
      'color': Colors.amber,
    },
    'risk': {
      'icon': CupertinoIcons.exclamationmark_shield,
      'color': Colors.red,
    }
  };

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final config = iconConfig[status] ??
        {
          'icon': CupertinoIcons.question_circle,
          'color': Colors.grey,
        };

    final icon = config['icon'] as IconData;
    final color = config['color'] as Color;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, right: 15, top: 13, bottom: 13),
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
              if (status == 'risk')
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[600],
                  ),
                  child: Center(
                      child: Icon(
                    CupertinoIcons.exclamationmark_bubble_fill,
                    size: 25,
                  )),
                )
              else
                CircleAvatar(
                  radius: responsive.radiusScale(23),
                  backgroundImage: NetworkImage(img!),
                ),
              SizedBox(
                width: responsive.widthScale(7),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status == 'risk')
                    Label(
                      size: 's',
                      label: 'Unauthorized Attempt',
                      isBold: true,
                    )
                  else
                    Label(
                      size: 's',
                      label: truncateWithEllipsis(name, 20),
                      isBold: true,
                    ),
                  Label(
                    size: 'xxs',
                    label: 'Exp: ${dateDotTimeFormat(dateTime)}',
                    color: Colors.grey,
                  )
                ],
              ),
            ],
          ),
          Icon(
            icon,
            color: color,
            size: 30,
          )
        ],
      ),
    );
  }
}
