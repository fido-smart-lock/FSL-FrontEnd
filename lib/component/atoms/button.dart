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
    return GestureDetector(
      onTap: onTap,
      child: Column(children: [
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 47,
          decoration: BoxDecoration(
              color: color ?? Color.fromARGB(255, 76, 148, 254),
              borderRadius: BorderRadius.circular(10)),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
        ),
      ]),
    );
  }
}
