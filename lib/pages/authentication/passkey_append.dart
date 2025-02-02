import 'package:corbado_auth/corbado_auth.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PasskeyAppendScreen extends HookWidget
    implements CorbadoScreen<PasskeyAppendBlock> {
  final PasskeyAppendBlock block;

  PasskeyAppendScreen(this.block);

  Future<void> logIn(String email, BuildContext context) async {
    
    try {
      debugPrint('login email : $email');
      final responseBody = await postJsonDataWithoutBody(
        apiUri: 'https://fsl-1080584581311.us-central1.run.app/login/$email',
      );

      if (responseBody != null && responseBody.isNotEmpty) {
        String userId = responseBody['userId'];
        int userCode = responseBody['userCode'];

        final storage = FlutterSecureStorage();

        await storage.write(key: 'userId', value: userId);
        await storage.write(key: 'userCode', value: userCode.toString());
      } else {
        throw Exception("Empty response body");
      }
    } catch (e) {}
  }

  Widget build(BuildContext context) {

    return Background(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Set up your passkey',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Quick and secure login using biometrics instead of passwords.',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 20),
            Button(
              onTap: () async {
                await block.passkeyAppend();
                await logIn(block.data.identifierValue, context);
              },
              label: 'Create passkey',
            ),
          ],
        ),
      ),
    );
  }
}
