import 'package:fido_smart_lock/component/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/person_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdminAndMemberSettingMain extends StatelessWidget {
  const AdminAndMemberSettingMain({
    super.key,
    required this.lockName,
    required this.lockLocation,
    required this.name,
    required this.role,
    required this.img
  });

  final String lockName;
  final String lockLocation;
  final List<String> name;
  final String role;
  final List<String> img;

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              CupertinoIcons.person_add,
              size: 30,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
              ],
            ),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderLabel(
            label: role,
            isBold: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: img.length, // Assumes all lists have the same length
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Person(
                    img: img[index],
                    name: name[index],
                    role: role,
                    button: 'remove',
                    lockName: lockName,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GuestSettingMain extends StatelessWidget {
  const GuestSettingMain({
    super.key,
    required this.lockName,
    required this.lockLocation,
    required this.name,
    required this.role,
    required this.img,
    required this.date,
    required this.time,
  });

  final String lockName;
  final String lockLocation;
  final List<String> name;
  final String role;
  final List<String> img;
  final List<String> date;
  final List<String> time;

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              CupertinoIcons.person_add,
              size: 30,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
              ],
            ),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderLabel(
            label: role,
            isBold: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: img.length, // Assumes all lists have the same length
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Person(
                    img: img[index],
                    name: name[index],
                    role: role,
                    date: date[index],
                    time: time[index],
                    button: 'remove',
                    lockName: lockName,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RequestSettingMain extends StatelessWidget {
  const RequestSettingMain({
    super.key,
    required this.lockName,
    required this.lockLocation,
    required this.name,
    required this.img,
    required this.dateTime
  });

  final String lockName;
  final String lockLocation;
  final List<String> name;
  final List<String> img;
  final List<String> dateTime;

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              CupertinoIcons.person_add,
              size: 30,
              color: Colors.white,
              shadows: <Shadow>[
                Shadow(color: Colors.black.withOpacity(0.50), blurRadius: 15.0)
              ],
            ),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderLabel(
            label: 'Request as Invited Guest',
            isBold: true,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: img.length, // Assumes all lists have the same length
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: PersonRequest(
                    img: img[index],
                    name: name[index],
                    lockName: lockName,
                    dateTime: dateTime[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
