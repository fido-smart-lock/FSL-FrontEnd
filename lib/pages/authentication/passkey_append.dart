import 'package:corbado_auth/corbado_auth.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasskeyAppendScreen extends HookWidget
    implements CorbadoScreen<PasskeyAppendBlock> {
  final PasskeyAppendBlock block;

  PasskeyAppendScreen(this.block);

  Widget build(BuildContext context) {
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final maybeError = block.error;
        if (maybeError != null) {
          debugPrint('Error: ${maybeError.detailedError()}');
        }
      });
    }, [block.error]);

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
              },
              label: 'Create passkey',
            ),
          ],
        ),
      ),
    );
  }
}
