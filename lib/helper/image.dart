import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<String?> uploadImageToCloudinary(File imageFile) async {
  try {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/ddpatzzeo/image/upload'); // Replace YOUR_CLOUD_NAME
    final request = http.MultipartRequest('POST', url);

    // Add upload preset and file
    request.fields['upload_preset'] = 'FSL_profile_picture'; // Replace YOUR_UPLOAD_PRESET
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    // Send request
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonResponse = json.decode(responseData);
      return jsonResponse['secure_url']; // Return the uploaded image URL
    } else {
      print('Failed to upload image: ${response.reasonPhrase}');
      return null;
    }
  } catch (e) {
    print('Error uploading image: $e');
    return null;
  }
}
