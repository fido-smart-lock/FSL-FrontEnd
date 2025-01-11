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
  required Future<void> Function() onProceed,
}) {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();

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
                          DatePickerWidget(
                            onDateSelected: (date) {
                              selectedDate = date;
                            },
                          ),
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
                          TimePickerWidget(
                            onTimeSelected: (time) {
                              selectedTime = time;
                            },
                          ),
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
                    onTap: () async {
                      Navigator.of(context).pop(); // Close the modal

                      // Combine the selected date and time into a DateTime object
                      DateTime combinedDateTime = DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      // Perform the API call or any other logic here
                      debugPrint(
                          'Selected DateTime: ${combinedDateTime.toIso8601String()}');
                      await onProceed();
                    }
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
