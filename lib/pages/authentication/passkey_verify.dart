import 'package:corbado_auth/corbado_auth.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PasskeyVerifyScreen extends HookWidget
    implements CorbadoScreen<PasskeyVerifyBlock> {
  final PasskeyVerifyBlock block;

  PasskeyVerifyScreen(this.block);

  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(
              'Login with your passkey',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Button(
            onTap: () async {
              await block.passkeyVerify();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Home(initialIndex: 0),
                ),
              );
            },
            label: 'Login with passkey',
          ),
          // const SizedBox(height: 10),
          // if (block.data.preferredFallback != null) SizedBox(
          //         width: double.infinity,
          //         height: 50,
          //         child: OutlinedTextButton(
          //           onTap: () => block.data.preferredFallback!.onTap(),
          //           content: block.data.preferredFallback!.label,
          //         ),
          //       ) else Container(),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }
}
