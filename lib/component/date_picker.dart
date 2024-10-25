import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime? _selectedDate;
  
  // Date format
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');
  
  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.calendar_badge_plus,
            color: Colors.white.withOpacity(0.75)
          ),
          SizedBox(width: responsive.widthScale(5),),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(responsive.radiusScale(3))
            ),
            child: SubLabel(
              label: _selectedDate != null 
                ? _dateFormat.format(_selectedDate!)
                : 'DD/MM/YYYY',
              color: Colors.white.withOpacity(0.75)
            ),
          ),
        ],
      ),
    );
  }
}
