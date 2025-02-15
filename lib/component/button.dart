import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button(
      {super.key,
      required this.onTap,
      required this.label,
      this.color,
      this.description});

  final VoidCallback onTap;
  final String label;
  final Color? color;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Column(
      children: [
        Container(
          height: responsive.heightScale(50),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: color ?? Colors.blueAccent,
            borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 30.0),
                child: Center(
                  child: Label(
                    size: 'm',
                    label: label,
                    isCenter: true,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class CapsuleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Color? labelColor;

  const CapsuleButton({
    super.key,
    required this.label,
    this.onTap,
    this.buttonColor = Colors.transparent,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: label == 'Remove'
                ? Colors.red.shade600
                : label == 'Invite'
                    ? Colors.green
                    : Colors.transparent,
          ),
        ),
        child: Label(
          size: 'xs',
          label: label,
          color: label == 'Remove'
              ? Colors.red.shade600
              : label == 'Invite'
                  ? Colors.green
                  : labelColor,
        ),
      ),
    );
  }
}

class ScanButton extends StatelessWidget {
  const ScanButton(
      {super.key,
      required this.lockName,
      required this.lockLocation,
      required this.lockId});

  final String lockId;
  final String lockName;
  final String lockLocation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LockScan(
              option: 'inLock',
              lockId: lockId,
              lockName: lockName,
              lockLocation: lockLocation,
            ),
          ),
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            CupertinoIcons.viewfinder,
            size: 70,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
            ],
          ),
          Icon(
            CupertinoIcons.lock_fill,
            size: 30,
            color: Colors.white,
            shadows: <Shadow>[
              Shadow(color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
            ],
          )
        ],
      ),
    );
  }
}

class DoubleButton extends StatelessWidget {
  const DoubleButton(
      {super.key,
      required this.labelText,
      required this.labelCapsuleButton,
      required this.buttonColor,
      this.labelCapsuleButtonColor = Colors.white,
      required this.onTapText,
      required this.onTapCapsuleButton});

  final String labelText;
  final String labelCapsuleButton;
  final Color buttonColor;
  final Color labelCapsuleButtonColor;
  final VoidCallback onTapText;
  final VoidCallback onTapCapsuleButton;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
            onTap: () {
              onTapText();
            },
            child: Label(
              size: 'xs',
              label: labelText,
              color: buttonColor,
            )),
        SizedBox(
          width: responsive.widthScale(15),
        ),
        CapsuleButton(
          onTap: onTapCapsuleButton,
          label: labelCapsuleButton,
          buttonColor: buttonColor,
          labelColor: labelCapsuleButtonColor,
        )
      ],
    );
  }
}
