import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

String timeDifference(String inputDateTimeString) {
  try {
    // Parse the input string to DateTime
    DateTime inputDateTime = DateTime.parse(inputDateTimeString);
    DateTime now = DateTime.now().toLocal();

    debugPrint('Input date: $inputDateTime');
    debugPrint('Now: $now');
    debugPrint('Difference: ${now.difference(inputDateTime)}');

    // Calculate the difference
    Duration difference = now.difference(inputDateTime);

    // If the date is yesterday
    DateTime yesterday = now.subtract(Duration(days: 1));
    bool isYesterday = inputDateTime.year == yesterday.year &&
        inputDateTime.month == yesterday.month &&
        inputDateTime.day == yesterday.day;

    // If the date is today
    bool isToday = inputDateTime.year == now.year &&
        inputDateTime.month == now.month &&
        inputDateTime.day == now.day;

    // Check if it was yesterday
    if (isYesterday) {
      return 'Yesterday, ${DateFormat('HH:mm').format(inputDateTime)}';
    }

    // Check if it was today
    if (isToday) {
      if (difference.inHours >= 1) {
        return '${difference.inHours}hr ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes}m ago';
      } else {
        return '${difference.inSeconds}s ago';
      }
    }

    // If none of the above, return the full date with a comma after the year
    return DateFormat('dd/MM/yyyy, HH:mm').format(inputDateTime);
  } catch (e) {
    return 'Invalid date format';
  }
}

String dateDotTimeFormat(String inputDateTimeString) {
  try {
    // Parse the string to DateTime
    DateTime inputDateTime = DateTime.parse(inputDateTimeString);

    // Format the date as DD/MM/YYYY
    String formattedDate = DateFormat('dd/MM/yyyy').format(inputDateTime);

    // Format the time as HH:MM
    String formattedTime = DateFormat('HH:mm').format(inputDateTime);

    // Return the array of formatted date and time
    return '$formattedDate • $formattedTime';
  } catch (e) {
    return 'Invalid format';
  }
}
