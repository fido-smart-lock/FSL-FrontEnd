import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/card/setting_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:flutter/material.dart';

class SecuritySetting extends StatelessWidget {
  const SecuritySetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
          centerTitle: true,
          title: Label(
            size: 'xxl',
            label: 'Security',
            isShadow: true,
          ),
        ),
        child: Column(
          children: [
            SettingCard(menu: 'password'),
            SettingCard(menu: 'biometric'),
            SettingCard(menu: 'hardware'),
            Spacer(),
            Align(
            alignment: Alignment.bottomCenter,
            child: Button(
              onTap: () {},
              label: 'Save Change',
            ),
          ),
          ],
        ));
  }
}
