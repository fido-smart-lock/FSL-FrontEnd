import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_scan.dart';
import 'package:flutter/material.dart';

class LockScanPass extends StatefulWidget {
  const LockScanPass({super.key, this.lockName = '', this.lockLocation = ''});

  final String lockName;
  final String lockLocation;

  @override
  State<LockScanPass> createState() => _LockScanPassState();
}

class _LockScanPassState extends State<LockScanPass> {
  late TextEditingController _passwordController;
  bool _isPasswordValid = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    setState(() {
      _isPasswordValid = _passwordController.text.trim().isNotEmpty;
    });

    if (_isPasswordValid) {
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => LockScan(
              option: 'inLockFinal',
              lockName: widget.lockName,
              lockLocation: widget.lockLocation,
            ),
        ));
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();

    _passwordController.addListener(() {
      setState(() {
        _isPasswordValid = _passwordController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
        appBar: AppBar(
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
              Label(size: 'l', isBold: true, label: 'Enter Password'),
              SizedBox(
                height: responsive.heightScale(10),
              ),
              CustomTextField(
                controller: _passwordController,
                labelText: 'Enter your password',
                labelColor: _isPasswordValid ? Colors.grey : Colors.red,
                mode: 'password',
                isValid: _isPasswordValid,
                validateText: 'Please enter your current password.',
              ),
              SizedBox(
                height: responsive.heightScale(250),
              ),
              Button(
              onTap: _validateAndSave,
              label: 'Save Change',
            ),
            ],
          ),
        ));
  }
}
