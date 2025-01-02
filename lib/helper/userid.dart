import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> saveUserId(String userId) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'userId', value: userId);
}

Future<String?> getUserId() async {
  final storage = FlutterSecureStorage();
  return await storage.read(key: 'userId'); // Returns null if not found
}

Future<void> removeUserIdAndUserCode() async {
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'userId');
  await storage.delete(key: 'userCode');
}

