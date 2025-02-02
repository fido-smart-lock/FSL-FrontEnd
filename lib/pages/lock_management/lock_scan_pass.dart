import 'package:corbado_auth/corbado_auth.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LockScanPass extends HookWidget
    implements CorbadoScreen<PasskeyVerifyBlock> {
  final PasskeyVerifyBlock? _block;
  final String lockName;
  final String lockLocation;

  const LockScanPass({
    PasskeyVerifyBlock? block,
    this.lockName = '',
    this.lockLocation = '',
  }) : _block = block;

  @override
  PasskeyVerifyBlock get block => _block!;

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
        appBar: AppBar(
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                  size: 'xxl',
                  label: lockName,
                  isShadow: true,
                ),
                Label(
                  size: 'l',
                  label: lockLocation,
                  color: Colors.grey.shade300,
                  isShadow: true,
                ),
              ],
            )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
              'Authenticate with your passkey',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),),
              SizedBox(
                height: responsive.heightScale(20),
              ),
              Button(
                onTap: () async {
                  await block.passkeyVerify();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LockScan(),
                    ),
                  );
                },
                label: 'Use Passkey',
              ),
            ],
          ),
        ));
  }
}
