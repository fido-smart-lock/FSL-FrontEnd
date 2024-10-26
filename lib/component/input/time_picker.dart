import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({super.key});

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  TimeOfDay? _selectedTime;

  // Function to show the time picker
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return GestureDetector(
      onTap: () => _selectTime(context),
      child: Row(
        children: [
          Icon(CupertinoIcons.clock, color: Colors.white.withOpacity(0.75),),
          SizedBox(width: responsive.widthScale(5),),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
            decoration: BoxDecoration(
              color: Colors.blueGrey[900],
              borderRadius: BorderRadius.circular(responsive.radiusScale(3))
            ),
            child: SubLabel(
              label: _selectedTime != null 
                ? _selectedTime!.format(context) 
                : 'HH:MM',
              color: Colors.white.withOpacity(0.75)
            ),
          ),
        ],
      ),
    );
  }
}
