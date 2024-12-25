// confirmation_modal.dart
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';

void showConfirmationModal(
  BuildContext context, {
  required String message,
  required VoidCallback onProceed,
  bool isCanNotUndone = false
}) {
  WoltModalSheet.show(
    context: context,
    pageListBuilder: (context) {
      return [
        WoltModalSheetPage(
          hasTopBarLayer: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(30, 30, 30, 80),
            child: Column(
              children: [
                Label(
                  size: 's',
                  label: message,
                  isBold: true,
                  isCenter: true,
                ),
                if(isCanNotUndone)
                  Label(
                    size: 'xs',
                    label: 'This action cannot be undone',
                    isCenter: true,
                    color: Colors.red,
                  ),
              ],
            ),
          ),
          stickyActionBar: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 30, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Label(size: 'xs', label: 'Cancel'),
                ),
                Gap(20),
                CapsuleButton(
                  label: 'Proceed',
                  buttonColor: Colors.green,
                  labelColor: Colors.white,
                  onTap: onProceed,
                ),
              ],
            ),
          ),
        ),
      ];
    },
    modalTypeBuilder: (context) {
      return WoltModalType.dialog();
    },
  );
}
