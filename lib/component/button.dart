import 'package:fido_smart_lock/component/label.dart';
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
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.indigoAccent,
        borderRadius: BorderRadius.circular(30),
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
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 30.0),
            child: SubHeaderLabel(
              label: label,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CapsuleButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Color? labelColor;

  const CapsuleButton(
      {super.key,
      required this.label,
      this.onTap,
      this.buttonColor = Colors.transparent,
      this.labelColor, });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
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
        child: SubLabel(
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
  const ScanButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}
