import 'package:fido_smart_lock/component/atoms/background.dart';
import 'package:fido_smart_lock/component/atoms/label.dart';
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
          title: MainHeaderLabel(label: 'Create New Lock'),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              Label(label: 'what type of lock you want to create?'),
              const Gap(25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LockScan(),
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 63, 63, 63),
                        borderRadius: BorderRadius.circular(13.0)),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 115, 115, 115),
                          ),
                          child: Center(
                              child: Icon(
                            CupertinoIcons.create,
                            size: 30,
                          )),
                        ),
                        Center(
                          child: Label(
                            label: 'Register new lock',
                            isBold: true,
                          ),
                        ),
                        const Gap(10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: SubLabel(
                              label: 'recommend for',
                              color: Color.fromARGB(255, 146, 148, 153),
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SubLabel(
                                label: '• ',
                                color: Color.fromARGB(255, 146, 148, 153)),
                            Expanded(
                              child: SubLabel(
                                  label:
                                      'new lock that never registered by any user',
                                  color: Color.fromARGB(255, 146, 148, 153)),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SubLabel(
                                label: '• ',
                                color: Color.fromARGB(255, 146, 148, 153)),
                            Expanded(
                              child: SubLabel(
                                  label:
                                      'lock that needs your full management',
                                  color: Color.fromARGB(255, 146, 148, 153)),
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
                      builder: (context) => LockScan(),
                    ),
                  );
                },
                child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 63, 63, 63),
                        borderRadius: BorderRadius.circular(13.0)),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 115, 115, 115),
                          ),
                          child: Center(
                              child: Icon(
                            CupertinoIcons.envelope_badge,
                            size: 30,
                          )),
                        ),
                        Center(
                          child: Label(
                            label: 'Request access to registered lock',
                            isBold: true,
                          ),
                        ),
                        const Gap(10),
                        Align(
                            alignment: Alignment.topLeft,
                            child: SubLabel(
                              label: 'recommend for',
                              color: Color.fromARGB(255, 146, 148, 153),
                            )),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SubLabel(
                                label: '• ',
                                color: Color.fromARGB(255, 146, 148, 153)),
                            Expanded(
                              child: SubLabel(
                                  label:
                                      'lock that other user own, but you need an access (as an invited guest)',
                                  color: Color.fromARGB(255, 146, 148, 153)),
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
