import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/card/setting_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';

class SettingsMain extends StatelessWidget {
  const SettingsMain({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Label(size: 'xxl', label: 'User Setting', isBold: true),
          centerTitle: false,
          leadingWidth: NavigationToolbar.kMiddleSpacing,),
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
          
                //user profile
                CircleAvatar(
                  backgroundImage: NetworkImage('https://i.postimg.cc/jdtLgPgX/jonathan-Smith.png'),
                  radius: responsive.radiusScale(50),
                ),
                SizedBox(height: responsive.heightScale(10),),
                Label(size: 'xl', label: 'Jonathan Smith', isBold: true,),
                Label(size: 'xs', label: 'jonathan.s@example.com'),
          
                //white space divider
                SizedBox(height: responsive.heightScale(20),),
          
                //menu list
                SettingCard(menu: 'profile'),
                SettingCard(menu: 'security'),
                SettingCard(menu: 'noti'),
          
                //divider
                Divider(),
          
                //support
                SettingCard(menu: 'support'),
              ],
            ),
          ),
        ),
      )
      );
  }
}
