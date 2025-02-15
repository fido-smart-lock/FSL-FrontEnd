import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/pages/lock_management/lock_scan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class LockCreate extends StatelessWidget {
  const LockCreate({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
          centerTitle: true,
          title: Label(size: 'xxl', label: 'Create New Lock'),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Label(size: 'm', label: 'what type of lock you want to create?'),
              const Gap(25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockScan(option: 'register'),
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(13.0)),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[600],
                          ),
                          child: Center(
                              child: Icon(
                            CupertinoIcons.create,
                            size: 30,
                          )),
                        ),
                        Center(
                          child: Label(
                            size: 'm',
                            label: 'Register new lock',
                            isBold: true,
                          ),
                        ),
                        const Gap(10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Label(
                              size: 's',
                              label: 'recommend for',
                              color: Colors.grey,
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Label(size: 's', label: '• ', color: Colors.grey),
                            Expanded(
                              child: Label(
                                  size: 's',
                                  label:
                                      'new lock that never registered by any user',
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Label(size: 's', label: '• ', color: Colors.grey),
                            Expanded(
                              child: Label(
                                  size: 's',
                                  label: 'lock that needs your full management',
                                  color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              const Gap(20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockScan(option: 'request'),
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(13.0)),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[600],
                          ),
                          child: Center(
                              child: Icon(
                            CupertinoIcons.envelope_badge,
                            size: 30,
                          )),
                        ),
                        Center(
                          child: Label(
                            size: 'm',
                            label: 'Request access to registered lock',
                            isBold: true,
                          ),
                        ),
                        const Gap(10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Label(
                              size: 's',
                              label: 'recommend for',
                              color: Colors.grey,
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Label(size: 's', label: '• ', color: Colors.grey),
                            Expanded(
                              child: Label(
                                  size: 's',
                                  label:
                                      'lock that other user own, but you need an access (as an invited guest)',
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    )),
              )
            ],
          ),
        ));
  }
}
