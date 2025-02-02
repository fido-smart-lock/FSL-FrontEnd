import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_scan.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class LockPassLocalAuth extends StatefulWidget {
  const LockPassLocalAuth(
      {super.key, required this.lockName, required this.lockLocation, required this.lockId});

  final String lockName;
  final String lockLocation;
  final String lockId;

  @override
  State<LockPassLocalAuth> createState() => _LockPassLocalAuthState();
}

class _LockPassLocalAuthState extends State<LockPassLocalAuth> {
  final LocalAuthentication auth = LocalAuthentication();

  bool canAuthenticateWithBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    debugPrint('Biometrics: $availableBiometrics');
    debugPrint('Can authenticate: $canAuthenticateWithBiometrics');

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.fingerprint)) {
      try {
        debugPrint('Authenticating');
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to unlock the smart lock',
            options: const AuthenticationOptions(
                biometricOnly: true, useErrorDialogs: false));
        if (didAuthenticate) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LockScan(
                option: 'inLockFinal',
                lockName: widget.lockName,
                lockLocation: widget.lockLocation,
                lockId: widget.lockId,
              ),
            ),
          );
        }
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
            centerTitle: true,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Label(
                  size: 'xxl',
                  label: widget.lockName,
                  isShadow: true,
                ),
                Label(
                  size: 'l',
                  label: widget.lockLocation,
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
                'Authenticate with passkey',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Button(
                onTap: () async {
                  _checkBiometrics();
                },
                label: 'Authenticate',
                color: Colors.blue,
              ),
            ],
          ),
        ));
  }
}
