import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/input/date_picker.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/input/time_picker.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/material.dart';

class AdminAndMemberAdd extends StatelessWidget {
  const AdminAndMemberAdd(
      {super.key,
      required this.lockName,
      required this.lockLocation,
      required this.role});

  final String lockName;
  final String lockLocation;
  final String role;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MainHeaderLabel(
                label: lockName,
                isShadow: true,
              ),
              SubHeaderLabel(
                label: lockLocation,
                color: Colors.grey.shade300,
                isShadow: true,
              ),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderLabel(
              label: 'Add New ${capitalizeFirstLetter(role)}',
              isBold: true,
            ),
            UserCodeInput(),
            SizedBox(
              height: responsive.heightScale(5),
            ),
            if (role == 'member')
              XtraSmallLabel(
                label:
                    'members have no expiration date access. If you want to add user with limit time of access, please considered using ‘invite new guest’',
                color: Colors.grey.shade500,
              )
          ],
        ));
  }
}

class GuestAdd extends StatelessWidget {
  const GuestAdd(
      {super.key,
      required this.lockName,
      required this.lockLocation,
      required this.role});

  final String lockName;
  final String lockLocation;
  final String role;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MainHeaderLabel(
                label: lockName,
                isShadow: true,
              ),
              SubHeaderLabel(
                label: lockLocation,
                color: Colors.grey.shade300,
                isShadow: true,
              ),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderLabel(
              label: 'Add New ${capitalizeFirstLetter(role)}',
              isBold: true,
            ),
            UserCodeInput(),
            SizedBox(
              height: responsive.heightScale(10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubLabel(label: 'Expiration Date'),
                    SizedBox(
                      height: responsive.widthScale(3),
                    ),
                    DatePickerWidget(),
                  ],
                ),
                SizedBox(
                  width: responsive.widthScale(10),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SubLabel(label: 'Time'),
                    SizedBox(
                      height: responsive.widthScale(3),
                    ),
                    TimePickerWidget(),
                  ],
                )
              ],
            ),
          ],
        ));
  }
}
