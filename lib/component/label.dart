import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';

class MainHeaderLabel extends StatelessWidget {
  const MainHeaderLabel({
    super.key,
    required this.label,
    this.name,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String label;
  final String? name;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    String displayText = name != null ? '$label, $name' : label;
    final responsive = Responsive(context);

    return Text(
      displayText,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(25.0),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}

class HeaderLabel extends StatelessWidget {
  const HeaderLabel({
    super.key,
    required this.label,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(20.0),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}

class SubHeaderLabel extends StatelessWidget {
  const SubHeaderLabel({
    super.key,
    required this.label,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(18.0),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}

class Label extends StatelessWidget {
  const Label({
    super.key,
    required this.label,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(16.0),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}

class SubLabel extends StatelessWidget {
  const SubLabel({
    super.key,
    required this.label,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(14.0),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}

class SmallLabel extends StatelessWidget {
  const SmallLabel({
    super.key,
    required this.label,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(12.0),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}

class XtraSmallLabel extends StatelessWidget {
  const XtraSmallLabel({
    super.key,
    required this.label,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String label;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Text(
      label,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(10.0),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}
