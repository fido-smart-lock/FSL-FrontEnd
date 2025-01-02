import 'dart:convert'; // For JSON encoding/decoding
import 'package:http/http.dart' as http;

// GET request
Future<dynamic> getJsonData({
  required String apiUri,
  Map<String, String>? headers,
}) async {
  try {
    headers ??= {'Content-Type': 'application/json'};

    final response = await http.get(Uri.parse(apiUri), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Success
    } else {
      throw Exception('Failed to GET data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error in GET request: $e');
  }
}

// POST request
Future<dynamic> postJsonData({
  required String apiUri,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
}) async {
  try {
    headers ??= {'Content-Type': 'application/json'};

    final response = await http.post(
      Uri.parse(apiUri),
      headers: headers,
      body: jsonEncode(body), // Encode body as JSON
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body); // Success
    } else {
      throw Exception('Failed to POST data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error in POST request: $e');
  }
}


// PUT request
Future<dynamic> putJsonData({
  required String apiUri,
  required Map<String, dynamic> body,
  Map<String, String>? headers,
}) async {
  try {
    headers ??= {'Content-Type': 'application/json'};

    final response = await http.put(
      Uri.parse(apiUri),
      headers: headers,
      body: jsonEncode(body), // Encode body as JSON
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body); // Success
    } else {
      throw Exception('Failed to PUT data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error in PUT request: $e');
  }
}


// DELETE request
Future<dynamic> deleteJsonData({
  required String apiUri,
  Map<String, String>? headers,
}) async {
  try {
    headers ??= {'Content-Type': 'application/json'};

    final response = await http.delete(Uri.parse(apiUri), headers: headers);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body); // Success
    } else {
      throw Exception('Failed to DELETE data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error in DELETE request: $e');
  }
}