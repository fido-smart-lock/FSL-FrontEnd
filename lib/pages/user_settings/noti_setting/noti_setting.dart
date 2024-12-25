import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/card/setting_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:flutter/material.dart';

class NotiSetting extends StatelessWidget {
const NotiSetting({ super.key });

  @override
  Widget build(BuildContext context){
    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Label(
          size: 'xxl',
          label: 'Notification Setting',
          isShadow: true,
        ),
      ),
      child: Column(
        children: [
          SettingCard(menu: 'push'),
          SettingCard(menu: 'email')
        ],
      ));
  }
}