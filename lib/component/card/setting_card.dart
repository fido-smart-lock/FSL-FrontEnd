import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingCard extends StatefulWidget {
  const SettingCard({super.key, required this.menu, this.description = '', required this.isToggle});

  final String menu;
  final String description;
  final bool isToggle;

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

    return Container(
      padding: EdgeInsets.fromLTRB(15, 15, 20, 20),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 5),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[900],
                ),
                child: Center(
                    child: Icon(
                  CupertinoIcons.envelope_badge,
                  size: 30,
                )),
              ),
              SizedBox(width: responsive.widthScale(10),),
              Column(
                children: [
                  Label(size: 'm', label: widget.menu),
                  if (widget.description != '') 
                    Label(size: 'xs', label: widget.description, color: Colors.grey,)
                ],
              ),
            ],
          ),
          if (!widget.isToggle)
           Icon(CupertinoIcons.chevron_right, size: 30,),
          if (widget.isToggle)
            Switch(value: toggleValue,
            activeColor: Colors.green,
             onChanged: (bool value) {
            setState(() {
              toggleValue = value;
            });
          },)
        ],
      ),
    );
  }
}
