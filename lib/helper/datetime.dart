import 'dart:core';
import 'package:intl/intl.dart';

String timeDifference(String inputDateTimeString) {
  try {
    // Parse the string to DateTime
    DateTime inputDateTime = DateTime.parse(inputDateTimeString);

    DateTime now = DateTime.now();

    // Calculate the difference
    Duration difference = now.difference(inputDateTime);

    // Return the formatted date if the difference is 30 days or more
    if (difference.inDays >= 30) {
      return DateFormat('MM/dd/yyyy').format(inputDateTime);
    }

    // Use the addPlural helper function for the largest time unit
    if (difference.inDays >= 1) {
      return '${addPlural(difference.inDays, 'day')} ago';
    } else if (difference.inHours >= 1) {
      return '${addPlural(difference.inHours, 'hour')} ago';
    } else if (difference.inMinutes >= 1) {
      return '${addPlural(difference.inMinutes, 'minute')} ago';
    } else {
      return '${addPlural(difference.inSeconds, 'second')} ago';
    }
  } catch (e) {
    return 'Invalid date format';
  }
}

// Helper function to handle singular/plural
String addPlural(int value, String unit) {
  return '$value $unit${value > 1 ? 's' : ''}';
}

List<String> convertDateTime(String inputDateTimeString) {
  try {
    // Parse the string to DateTime
    DateTime inputDateTime = DateTime.parse(inputDateTimeString);

    // Format the date as DD/MM/YYYY
    String formattedDate = DateFormat('dd/MM/yyyy').format(inputDateTime);

    // Format the time as HH:MM
    String formattedTime = DateFormat('HH:mm').format(inputDateTime);

    // Return the array of formatted date and time
    return [formattedDate, formattedTime];
  } catch (e) {
    return ['Invalid date format', ''];
  }
}
