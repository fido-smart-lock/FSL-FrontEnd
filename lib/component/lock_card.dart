import 'package:dotted_border/dotted_border.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class LockCard extends StatelessWidget {
  final String? img;
  final String name;
  final VoidCallback onTap;
  final bool? isBadged;

  const LockCard({
    super.key,
    this.img,
    required this.name,
    required this.onTap,
    this.isBadged,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return GestureDetector(
      onTap: onTap,
      child: badges.Badge(
        badgeContent: Icon(
          CupertinoIcons.photo,
          color: Colors.white,
        ),
        showBadge: isBadged ?? false,
        badgeStyle: badges.BadgeStyle(
          badgeColor: Colors.blue,
          padding: EdgeInsets.all(5),
        ),
        child: Container(
          width: responsive.widthScale(200),
          height: responsive.heightScale(200),
          decoration: BoxDecoration(
            color: img == null
                ? Colors.grey // Default background color
                : null, // No color if image is provided
            image: img != null
                ? DecorationImage(
                    image: NetworkImage(img!),
                    fit: BoxFit.cover,
                  )
                : null,
            borderRadius: BorderRadius.circular(13.0),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.0),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Color.fromARGB(255, 52, 52, 52)],
                  stops: [0.15, 1],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddLockCard extends StatelessWidget {
  final VoidCallback onTap;

  const AddLockCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: [13, 13],
        strokeWidth: 2,
        radius: Radius.circular(13.0),
        color: Colors.grey,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Icon(
              CupertinoIcons.add,
              size: 30,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
