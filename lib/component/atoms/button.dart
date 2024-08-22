import 'package:fido_smart_lock/component/atoms/label.dart';
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

  const CapsuleButton({super.key, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: label == 'Remove'
                ? Colors.red.shade600
                : label == 'Invite'
                    ? Colors.green
                    : Colors.white,
          ),
        ),
        child: SubLabel(
          label: label,
          color: label == 'Remove'
              ? Colors.red.shade600
              : label == 'Invite'
                  ? Colors.green
                  : Colors.white,
        ),
      ),
    );
  }
}
