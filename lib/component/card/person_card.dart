import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/modal/confirmation_modal.dart';
import 'package:fido_smart_lock/component/modal/confirmation_with_date_time_modal.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/datetime.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:gap/gap.dart';

class Person extends StatelessWidget {
  final bool isAdmin;
  final bool isWaitingForApproval;
  final String? img;
  final String name;
  final String? role;
  final String? button;
  final String? lockName;
  final String? dateTime;
  final String? expirationDateTime;
  final String userId;
  final String desUserId;
  final String lockId;
  final String invitedRole;
  final Future<void> Function(String userId, String lockId)? onRemovePeople;

  const Person(
      {super.key,
      this.isAdmin = false,
      this.isWaitingForApproval = false,
      this.img,
      required this.name,
      this.role,
      this.button,
      this.lockName,
      this.dateTime,
      this.userId = '',
      this.desUserId = '',
      this.lockId = '',
      this.invitedRole = '',
      this.expirationDateTime,
      this.onRemovePeople});

  String _getRoleDisplay(bool isWaitingForApproval, String role) {
    if (isWaitingForApproval) {
      return '$role • pending removal';
    }
    return role;
  }

  Future<void> sendInviteRequest(BuildContext context) async {
    const storage = FlutterSecureStorage();

    try {
      String? srcUserId = await storage.read(key: 'userId');
      if (srcUserId == null || srcUserId.isEmpty) {
        throw Exception('srcUserId is missing');
      }
      if (desUserId.isEmpty || lockId.isEmpty) {
        throw Exception('desUserId or lockId is missing.');
      }

      final body = {
        'srcUserId': srcUserId,
        'desUserId': desUserId,
        'role': invitedRole, // Default empty string
        'lockId': lockId,
        'datetime': expirationDateTime ?? "", // Avoid null
      };

      // ignore: unused_local_variable
      final response = await postJsonData(
        apiUri: 'https://fsl-1080584581311.us-central1.run.app/invitation',
        body: body,
      );
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Great!',
          message:
              'Invite sent successfully!',
          contentType: ContentType.success,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);

    } catch (e) {
      RegExp regExp = RegExp(r'(\d{3})'); // Matches three digits (e.g., 409)
      String? statusCode = regExp.stringMatch(e.toString());

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Oh no!',
          message:
              'Something went wrong, please try again. status code $statusCode',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10, right: 15, top: 13, bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[850],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: responsive.radiusScale(23),
                backgroundImage: NetworkImage(img ?? ''),
              ),
              SizedBox(
                width: responsive.widthScale(7),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Label(
                    size: 's',
                    label: truncateWithEllipsis(name, 15),
                    isBold: true,
                  ),
                  if (role != null && role != 'guest')
                    Label(
                      size: 'xs',
                      label: _getRoleDisplay(isWaitingForApproval, role!),
                      color: Colors.grey,
                    )
                  else if (role == 'guest' && dateTime != null)
                    Label(
                      size: 'xxs',
                      label: 'Exp: ${dateDotTimeFormat(dateTime!)}',
                      color: Colors.grey,
                    )
                ],
              ),
            ],
          ),
          if (button == 'remove' && isAdmin)
            CapsuleButton(
              label: 'Remove',
              onTap: () {
                showConfirmationModal(context,
                    message:
                        'Do you want to remove $name from $role of $lockName lock?',
                    onProceed: () async {
                  await onRemovePeople!(userId, lockId);
                });
              },
            )
          else if (button == 'invite' && isAdmin)
            CapsuleButton(
              label: 'Invite',
              onTap: () {
                showConfirmationModal(
                  context,
                  message:
                      'Do you want to add $name as $role of $lockName lock?',
                  description:
                      'This person will have full control of the lock.',
                  onProceed: () async {
                    sendInviteRequest(context); // Call API on Proceed
                  },
                );
              },
            )
        ],
      ),
    );
  }
}

class PersonRequest extends StatelessWidget {
  final String? img;
  final String name;
  final String? role;
  final String lockName;
  final String dateTime;
  final String notiId;
  final String lockId;
  final Future<void> Function(String lockId, String expireDatetime)?
      onAcceptRequest;
  final Future<void> Function(String notiId)? onDeclineRequest;

  const PersonRequest(
      {super.key,
      this.img,
      required this.name,
      this.role,
      required this.lockName,
      required this.dateTime,
      required this.notiId,
      required this.lockId,
      this.onAcceptRequest,
      this.onDeclineRequest});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15, right: 20, top: 13, bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(responsive.radiusScale(15)),
        color: Colors.grey[850], // Include color within BoxDecoration
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: responsive.radiusScale(23),
                  backgroundImage: NetworkImage(img!),
                ),
                const Gap(13),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Label(
                      size: 's',
                      label: truncateWithEllipsis(name, 25),
                      isBold: true,
                    ),
                    Label(
                      size: 'xxs',
                      label: 'Request pending ${timeDifference(dateTime)}',
                      color: Colors.grey,
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
        Gap(10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
                onTap: () async {
                  await onDeclineRequest!(notiId);
                },
                child: Label(
                  size: 'xs',
                  label: 'Decline',
                  color: Colors.red,
                )),
            Gap(20),
            CapsuleButton(
              label: 'Accept',
              buttonColor: Colors.green,
              labelColor: Colors.white,
              onTap: () async {
                showConfirmationWithDateTimeModal(context,
                    message:
                        'Do you want to accept $name request to unlock $lockName?',
                    onProceed: () async {
                  String expireDatetime = DateTime.now().toIso8601String();


                  if (onAcceptRequest != null) {
                    await onAcceptRequest!(notiId, expireDatetime);
                  }
                });
              },
            )
          ],
        )
      ]),
    );
  }
}

class PersonHistoryCard extends StatelessWidget {
  const PersonHistoryCard(
      {super.key,
      required this.name,
      this.img,
      required this.dateTime,
      required this.status});

  final String name;
  final String? img;
  final String dateTime;
  final String status;

  static const iconConfig = {
    'connect': {
      'icon': CupertinoIcons.check_mark_circled,
      'color': Colors.green,
    },
    'req': {
      'icon': CupertinoIcons.bell,
      'color': Colors.amber,
    },
    'risk': {
      'icon': CupertinoIcons.exclamationmark_shield,
      'color': Colors.red,
    }
  };

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    final config = iconConfig[status] ??
        {
          'icon': CupertinoIcons.question_circle,
          'color': Colors.grey,
        };

    final icon = config['icon'] as IconData;
    final color = config['color'] as Color;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 10, right: 15, top: 13, bottom: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.grey[850], // Include color within BoxDecoration
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              if (status == 'risk')
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[600],
                  ),
                  child: Center(
                      child: Icon(
                    CupertinoIcons.exclamationmark_bubble_fill,
                    size: 25,
                  )),
                )
              else
                CircleAvatar(
                  radius: responsive.radiusScale(23),
                  backgroundImage: NetworkImage(img!),
                ),
              SizedBox(
                width: responsive.widthScale(7),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (status == 'risk')
                    Label(
                      size: 's',
                      label: 'Unauthorized Attempt',
                      isBold: true,
                    )
                  else
                    Label(
                      size: 's',
                      label: truncateWithEllipsis(name, 20),
                      isBold: true,
                    ),
                  Label(
                    size: 'xxs',
                    label: dateDotTimeFormat(dateTime),
                    color: Colors.grey,
                  )
                ],
              ),
            ],
          ),
          Icon(
            icon,
            color: color,
            size: 30,
          )
        ],
      ),
    );
  }
}
