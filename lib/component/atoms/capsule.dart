import 'package:flutter/material.dart';

class LocationCapsule extends StatelessWidget {
  final String location;
  final bool? isSelected;
  final VoidCallback? onTap;
  final bool? isCustomized;

  const LocationCapsule({
    required this.location,
    this.isSelected,
    this.onTap,
    this.isCustomized,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: isCustomized == true
                ? Colors.white
                : isSelected == true
                    ? Colors.blue
                    : Colors.grey,
          ),
        ),
        child: Text(
          location,
          style: TextStyle(
            fontWeight:
                isSelected == true ? FontWeight.bold : FontWeight.normal,
            color: isCustomized == true
                ? Colors.white
                : isSelected == true
                    ? Colors.blue
                    : Colors.grey,
          ),
        ),
      ),
    );
  }
}
