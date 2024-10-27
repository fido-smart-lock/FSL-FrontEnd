import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  const Label({
    super.key,
    required this.size,
    required this.label,
    this.name,
    this.isBold,
    this.color,
    this.isCenter,
    this.isShadow,
  });

  final String size;
  final String label;
  final String? name;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isShadow;

  static const sizeConfig = {
    'xxs': 10.0,
    'xs': 12.0,
    's': 14.0,
    'm': 16.0,
    'l': 18.0,
    'xl': 20.0,
    'xxl': 25.0
  };

  @override
  Widget build(BuildContext context) {
    String displayText = name != null ? '$label, $name' : label;
    final fontSize = sizeConfig[size] as double;
    final responsive = Responsive(context);

    return Text(
      displayText,
      style: TextStyle(
        color: color ?? Colors.white,
        fontSize: responsive.fontScale(fontSize),
        fontWeight: isBold == true ? FontWeight.bold : FontWeight.normal,
        shadows: isShadow == true
            ? [Shadow(color: Colors.black.withOpacity(0.75), blurRadius: 15.0)]
            : null,
      ),
      textAlign: isCenter == true ? TextAlign.center : TextAlign.start,
    );
  }
}
