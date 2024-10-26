String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input; // Return if input is empty
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

String truncateWithEllipsis(String input, int n) {
  int k = input.length; // Automatically calculate the length of the input string
  
  // Check if the input length exceeds the limit 'n'
  if (k > n) {
    // Return the truncated string with ellipsis
    return input.substring(0, n) + '...';
  }
  // If the string length is less than or equal to 'n', return the original string
  return input;
}

// Helper function to handle singular/plural
String addPlural(int value, String unit) {
  return '$unit${value > 1 ? 's' : ''}';
}

String addLabelPossessive(String label) {
  // Check if the location name ends with 's' to determine possessive form
  return label.endsWith('s') 
      ? "$label'"    // Only add an apostrophe if it ends with 's'
      : "$label's";  // Otherwise, add "'s"
}