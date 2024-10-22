import 'package:fido_smart_lock/component/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/material.dart';

class AdminAndGuestAdd extends StatelessWidget {
  const AdminAndGuestAdd(
      {super.key, required this.lockName, required this.lockLocation, required this.role});

  final String lockName;
  final String lockLocation;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MainHeaderLabel(
                label: lockName,
                isShadow: true,
              ),
              SubHeaderLabel(
                label: lockLocation,
                color: Colors.grey.shade300,
                isShadow: true,
              ),
            ],
          ),
        ),
        child: Column(
          children: [
            HeaderLabel(label: 'Add New ${capitalizeFirstLetter(role)}')
          ],));
  }
}
