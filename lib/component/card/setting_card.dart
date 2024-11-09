import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/user_settings/setting_menu_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingCard extends StatefulWidget {
  const SettingCard({super.key, required this.menu});

  final String menu;

  @override
  State<SettingCard> createState() => _SettingCardState();
}

class _SettingCardState extends State<SettingCard> {
  bool toggleValue = false;

  final WidgetStateProperty<Icon?> thumbIcon =
      WidgetStateProperty.resolveWith<Icon?>(
    (Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(CupertinoIcons.check_mark);
      }
      return const Icon(CupertinoIcons.xmark);
    },
  );

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final config = getMenuConfig(context)[widget.menu] ??
        {
          'icon': CupertinoIcons.question_circle,
          'menuName': 'Unknown Menu',
          'description': '',
          'isToggle': false,
          'onTap': () {}
        };

    final icon = config['icon'] as IconData;
    final menuName = config['menuName'] as String;
    final description = config['description'] as String;
    final isToggle = config['isToggle'] as bool;
    final onTap = config['onTap'] as VoidCallback;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.fromLTRB(15, 10, 20, 10),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[900],
                  ),
                  child: Center(
                      child: Icon(
                    icon,
                    size: 25,
                  )),
                ),
                SizedBox(
                  width: responsive.widthScale(10),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        size: 'm',
                        label: menuName,
                      ),
                      if (description != '')
                        Label(
                          size: 'xxs',
                          label: description,
                          color: Colors.grey,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isToggle)
              Icon(
                CupertinoIcons.chevron_right,
                size: 20,
              ),
            if (isToggle)
              Switch(
                value: toggleValue,
                inactiveTrackColor: Colors.transparent,
                activeColor: Colors.green,
                onChanged: (bool value) {
                  setState(() {
                    toggleValue = value;
                  });
                },
              )
          ],
        ),
      ),
    );
  }
}
