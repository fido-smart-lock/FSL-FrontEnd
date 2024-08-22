import 'package:flutter/material.dart';

class MainHeaderLabel extends StatelessWidget {
  const MainHeaderLabel({super.key, required this.label, this.name, this.isBold, this.color, this.isCenter});

  final String label;
  final String? name;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;

  @override
  Widget build(BuildContext context) {
    String displayText = name != null ? '$label, $name' : label;

    return Text(
      displayText,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: 25.0,
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start
    );
  }
}

class HeaderLabel extends StatelessWidget {
  const HeaderLabel({super.key, required this.label, this.isBold, this.color, this.isCenter});
  
  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;

  @override
  Widget build(BuildContext context) {

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: 20.0,
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start
    );
  }
}

class SubHeaderLabel extends StatelessWidget {
  const SubHeaderLabel({super.key, required this.label, this.isBold, this.color, this.isCenter});
  
  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;

  @override
  Widget build(BuildContext context) {

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: 18.0,
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start
    );
  }
}

class Label extends StatelessWidget {
  const Label({super.key, required this.label, this.isBold, this.color, this.isCenter});

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;

  @override
  Widget build(BuildContext context) {

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: 16.0,
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,

    );
  }
}

class SubLabel extends StatelessWidget {
  const SubLabel({super.key, required this.label, this.isBold, this.color, this.isCenter});

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;

  @override
  Widget build(BuildContext context) {

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: 14.0,
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}