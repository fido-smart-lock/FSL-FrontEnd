import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:gap/gap.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class Person extends StatelessWidget {
  final String? img;
  final String name;
  final String? role;
  final String? button;
  final String lockName;
  final String? date;
  final String? time;

  const Person({
    super.key,
    this.img,
    required this.name,
    this.role,
    this.button,
    required this.lockName, this.date, this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, right: 20, top: 13, bottom: 13),
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
              ProfilePicture(
                name: name, // Use the name passed to the widget
                radius: 29,
                fontsize: 21,
                img: img, // Use the img passed to the widget
              ),
              const Gap(13),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    label: name,
                    isBold: true,
                  ),
                  if (role != null && role != 'guest')
                    SubLabel(
                      label: role!,
                      color: Colors.grey,
                    )
                  else if (role == 'guest')
                    SubLabel(
                      label: 'Expired: $date • $time',
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
                WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (context) {
                    return [
                      WoltModalSheetPage(
                        hasTopBarLayer: false,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(30,30,30,80),
                          child: Label(
                            label:
                                'Do you want to remove $name from $role of $lockName lock?',
                            isBold: true,
                            isCenter: true,
                          ),
                        ),
                        stickyActionBar: Padding(
                          padding: const EdgeInsets.fromLTRB(0,0,30,30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: Navigator.of(context).pop,
                                child: Label(label: 'Cancel')),
                              Gap(20),
                              CapsuleButton(
                                label: 'Proceed',
                                buttonColor: Colors.green,
                                labelColor: Colors.white,)
                            ],
                          ),
                        ),
                      )
                    ];
                  },
                  modalTypeBuilder: (context) {
                    return WoltModalType.dialog();
                  },
                );
              },
            )
          else if (button == 'invite')
            CapsuleButton(
              label: 'Invite',
              onTap: () {
                
              },
            )
        ],
      ),
    );
  }
}