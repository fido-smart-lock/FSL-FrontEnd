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
    this.isJustify,
    this.isUnderlined,
  });

  final String size;
  final String label;
  final String? name;
  final bool? isBold;
  final Color? color;
  final bool? isCenter;
  final bool? isJustify;
  final bool? isShadow;
  final bool? isUnderlined;

  double _getFontSize(String size) {
    switch (size) {
      case 'xxs':
        return 10.0;
      case 'xs':
        return 12.0;
      case 's':
        return 14.0;
      case 'm':
        return 16.0;
      case 'l':
        return 18.0;
      case 'xl':
        return 20.0;
      case 'xxl':
        return 25.0;
      default:
        return 14.0; // Default size
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayText = name != null ? '$label, $name' : label;
    final fontSize = _getFontSize(size);
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
        decoration: isUnderlined == true ? TextDecoration.underline : null
      ),
      textAlign: isCenter == true
          ? TextAlign.center
          : isJustify == true
              ? TextAlign.justify
              : TextAlign.start,
      softWrap: true,
      overflow: TextOverflow.visible,
    );
  }
}
