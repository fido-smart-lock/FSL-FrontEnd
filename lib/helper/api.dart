import 'dart:convert'; // For JSON decoding
import 'package:http/http.dart' as http;

/// A reusable function to fetch JSON data from an API.
/// [apiUri] is the URI of the API endpoint.
/// Returns the decoded JSON data or throws an exception if an error occurs.
Future<dynamic> fetchJsonData(String apiUri) async {
  try {
    final response = await http.get(Uri.parse(apiUri));

    if (response.statusCode == 200) {
      // Parse the JSON data
      return jsonDecode(response.body);
    } else {
      // Handle HTTP errors
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  } catch (e) {
    // Handle any other errors
    throw Exception('Error occurred while fetching data: $e');
  }
}
