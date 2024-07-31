import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropdownCapsule extends StatefulWidget {
  final List<String> items;

  const DropdownCapsule({super.key, required this.items});

  @override
  _DropdownCapsuleState createState() => _DropdownCapsuleState();
}

class _DropdownCapsuleState extends State<DropdownCapsule> {
  String? _selectedItem;

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      _selectedItem = widget.items[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: const Row(
          children: [
            Icon(
              CupertinoIcons.arrowtriangle_down_circle_fill,
              color: Colors.white,
            ),
          ],
        ),
        items: widget.items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        value: _selectedItem,
        onChanged: (value) {
          setState(() {
            _selectedItem = value;
          });
        },
        buttonStyleData: ButtonStyleData(
          // height: 33,
          width: 130,
          padding: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: Colors.transparent,
            ),
            color: Color.fromRGBO(100, 72, 72, 1),
          ),
          elevation: 2,
        ),
        iconStyleData: IconStyleData(
          icon: Transform.rotate(
            angle: 90 * pi / 180,
            child: Icon(
              CupertinoIcons.play_fill,
            ),
          ),
          iconSize: 12,
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Color.fromRGBO(89, 66, 66, 1),
          ),
          offset: Offset(-10, -3),
          scrollbarTheme: ScrollbarThemeData(
            radius: Radius.circular(40),
            thickness: WidgetStateProperty.all(3),
            thumbVisibility: WidgetStateProperty.all(true),
          ),
        ),
        menuItemStyleData: MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14)
        ),
      ),
    );
  }
}
