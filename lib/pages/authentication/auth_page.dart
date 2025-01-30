import 'package:corbado_auth/corbado_auth.dart';
import 'package:fido_smart_lock/auth_provider.dart';
import 'package:fido_smart_lock/pages/authentication/login_main.dart';
import 'package:fido_smart_lock/pages/authentication/passkey_append.dart';
import 'package:fido_smart_lock/pages/authentication/passkey_verify.dart';
import 'package:fido_smart_lock/pages/authentication/signup/signup_main.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthPage extends HookConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final corbadoAuth = ref.watch(corbadoProvider);

    return Scaffold(
      body: Center(
        child: CorbadoAuthComponent(
            corbadoAuth: corbadoAuth,
            components: CorbadoScreens(
              signupInit: SignUpMain.new,
              loginInit: LoginMain.new,
              passkeyAppend: PasskeyAppendScreen.new,
              passkeyVerify: PasskeyVerifyScreen.new,
            )),
      ),
    );
  }
}