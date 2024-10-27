import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/date_picker.dart';
import 'package:fido_smart_lock/component/input/time_picker.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

void showConfirmationWithDateTimeModal(
  BuildContext context, {
  required String message,
  required VoidCallback onProceed,
}) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: Container(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 80),
            child: Column(
              children: [
                Label(
                  size: 's',
                  label: message,
                  isBold: true,
                  isCenter: true,
                ),
                Gap(5),
                Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                            size: 's',
                            label: 'Expiration Date',
                            color: Colors.white.withOpacity(0.75),
                          ),
                          Gap(3),
                          DatePickerWidget(),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Label(
                              size: 's',
                              label: 'Time',
                              color: Colors.white.withOpacity(0.75)),
                          Gap(3),
                          TimePickerWidget(),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          stickyActionBar: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Label(size: 'xs', label: 'Cancel')),
                Gap(20),
                CapsuleButton(
                  label: 'Proceed',
                  buttonColor: Colors.green,
                  labelColor: Colors.white,
                )
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
}
