// data.dart
import 'package:fido_smart_lock/component/label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final Map<String, Map<String, dynamic>> faqDataList = {
  'status': {
    'question': 'What is \'Lock Status\'?',
    'answer': Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
            size: 'xs',
            isJustify: true,
            label:
                'The status of your smart lock indicates the security level based on recent attempts to unlock. Here\'s a breakdown of the statuses: \n\n'),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.lock_shield,
              color: Colors.green,
            ),
            SizedBox(width: 5,),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(size: 'xs', isBold: true, label: 'Secure:'),
                  Label(
                      size: 'xs',
                      isJustify: true,
                      label:
                          'This status means your smart lock hasn\'t detected any recent unauthorized attempts to unlock it. That\'s good news!\n'),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.exclamationmark_shield,
              color: Colors.amber,
            ),
            SizedBox(width: 5,),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(size: 'xs', isBold: true, label: 'Warning:'),
                  Label(
                      size: 'xs',
                      isJustify: true,
                      label:
                          'This status indicates that someone may have tried to unlock your smart lock without authorization one to three times recently. We recommend you to be cautious and monitor the activity around your door.\n'),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              CupertinoIcons.shield_slash,
              color: Colors.red,
            ),
            SizedBox(width: 5,),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(size: 'xs', isBold: true, label: 'In mature risk:'),
                  Label(
                      size: 'xs',
                      isJustify: true,
                      label:
                          'This status signifies a higher security risk as there have been four or more unauthorized attempts to unlock your smart lock recently. It\'s advisable to take immediate action to secure your lock, such as setup a camera or considering contacting a security professional.\n\n'),
                ],
              ),
            ),
          ],
        ),
        Label(size: 'xs', isBold: true, label: 'Additional Notes:'),
        Label(
            size: 'xs',
            isJustify: true,
            label:
                'You can find more details about unauthorized attempts on the notification page within the app. This information includes the time and number of attempts, but won\'t provide additional features like contacting authorities or capturing snapshots. \nChoosing "ignore" on a warning notification signifies the system will consider the attempts non-threatening. We highly recommend verifying the attempts are not a security risk before selecting "ignore."'),
      ],
    ),
  },
};
