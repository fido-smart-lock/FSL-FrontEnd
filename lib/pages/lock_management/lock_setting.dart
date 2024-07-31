import 'package:fido_smart_lock/component/atoms/background.dart';
import 'package:fido_smart_lock/component/atoms/label.dart';
import 'package:flutter/material.dart';

class LockSetting extends StatelessWidget {
  const LockSetting({super.key, required this.appBarTitle});

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
          title: MainHeaderLabel(label: appBarTitle),
        ),
        child: Text('Hi'));
  }
}
