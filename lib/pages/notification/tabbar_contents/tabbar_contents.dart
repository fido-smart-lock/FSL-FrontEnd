// ignore_for_file: use_build_context_synchronously

import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/material.dart';
import 'package:fido_smart_lock/component/card/noti_card.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

class TabBarContents extends StatefulWidget {
  const TabBarContents({super.key, required this.mode, this.subMode});

  final String mode;
  final String? subMode;

  @override
  State<TabBarContents> createState() => _TabBarContentsState();
}

class _TabBarContentsState extends State<TabBarContents> {
  List<Map<String, dynamic>>? dataList = [];
  bool isDataLoaded = false;

  String getApiUri(String mode, String userId) {
    switch (mode) {
      case 'req':
        return 'https://fsl-1080584581311.us-central1.run.app/notification/req/$userId';
      case 'other':
        return 'https://fsl-1080584581311.us-central1.run.app/notification/other/$userId';
      case 'warning':
        return 'https://fsl-1080584581311.us-central1.run.app/notification/warning/main/$userId';
      case 'connect':
        return 'https://fsl-1080584581311.us-central1.run.app/notification/connect/$userId';
      default:
        throw ArgumentError('Invalid mode: $mode');
    }
  }

  String getSvg(String mode) {
    switch (mode) {
      case 'warning':
        return 'assets/svg/restSecurity.svg';
      default:
        return 'assets/svg/findMail.svg';
    }
  }

  String _getMainTextLabel(String mode) {
    switch (mode) {
      case 'warning':
        return 'Everything looks secure!';
      default:
        return 'Peace and quiet? Enjoy it while it lasts!';
    }
  }

  String _getSubTextLabel(String mode) {
    switch (mode) {
      case 'warning':
        return 'sit back and relax,we will tell you if \'things\' happen.';
      default:
        return 'Looks like nobody\'s knocking (yet).';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserNotification();
  }

  Future<void> fetchUserNotification() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      String apiUri = getApiUri(widget.mode, userId);

      try {
        var data = await getJsonData(apiUri: apiUri);
        setState(() {
          isDataLoaded = true;
          dataList = List<Map<String, dynamic>>.from(data['dataList']);
          debugPrint('DataList: $dataList');
        });
      } catch (e) {
        setState(() {
          isDataLoaded = true;
          dataList = [];
        });
        debugPrint('Error: $e');
      }
    } else {
      setState(() {
        isDataLoaded = true;
        dataList = [];
      });
      debugPrint('User ID not found in secure storage.');
    }
  }

  Future<void> deleteAllNotificationWarning(String lockId) async {
    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/delete/notification/warning/$lockId';

    try {
      final response = await deleteJsonData(apiUri: apiUri);
      debugPrint('Delete successful: $response');
      await fetchUserNotification();
    } catch (e) {
      debugPrint('Error deleting notification warning: $e');
    }
  }

  Future<void> declineInvitation(String notiId) async {
    debugPrint('Decline invitation with notiId: $notiId');
    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/declineInvitation/$notiId';

    try {
      final response = await deleteJsonData(apiUri: apiUri);
      debugPrint('Delete successful: $response');
      await fetchUserNotification();
    } catch (e) {
      debugPrint('Error deleting notification warning: $e');
    }
  }

  Future<void> acceptAllRequest(String lockId, [String? expireDatetime]) async {
    Map<String, dynamic> requestBody = {
      'lockId': lockId,
      'expireDatetime': expireDatetime ?? ''
    };

    debugPrint('accept all request body: $requestBody');

    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/acceptAllRequest';

    try {
      var response = await putJsonData(apiUri: apiUri, body: requestBody);
      debugPrint('accept all request: $response');
      await fetchUserNotification();
    } catch (e) {
      debugPrint('Error accepting all request: $e');
    }
  }

  Future<void> acceptRemoval(String lockId) async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/acceptRemoval/$userId/$lockId';
      try {
        // ignore: unused_local_variable
        var response = await putJsonDataWithoutBody(apiUri: apiUri);
        debugPrint('accept removal: $response');
        await fetchUserNotification();
      } catch (e) {
        debugPrint('Error while decline: $e');
      }
    } else {
      debugPrint('User ID not found in secure storage.');
    }
  }

  Future<void> declineRemoval(String lockId) async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app//declineRemoval/$userId/$lockId';

    try {
      final response = await deleteJsonData(apiUri: apiUri);
      debugPrint('decline successful: $response');
      await fetchUserNotification();
    } catch (e) {
      debugPrint('Error deleting notification warning: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (!isDataLoaded) {
      return Expanded(child: Center(child: CircularProgressIndicator()));
    } else if (dataList!.isEmpty) {
      return Expanded(
        child: Center(
          child: Column(
            children: [
              SvgPicture.asset(getSvg(widget.mode),
                  semanticsLabel: 'Empty State',
                  height: responsive.heightScale(150)),
              SizedBox(
                height: 20,
              ),
              Label(
                size: 's',
                label: _getMainTextLabel(widget.mode),
                isBold: true,
                color: Colors.grey,
                isCenter: true,
              ),
              SizedBox(
                height: 10,
              ),
              Label(
                size: 'xs',
                label: _getSubTextLabel(widget.mode),
                isCenter: true,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: dataList!.length,
        itemBuilder: (context, index) {
          // Get each item data from the parsed JSON
          final item = dataList![index];

          return Column(
            children: [
              NotiCard(
                notiId: item['notiId'] ?? '',
                dateTime: item['dateTime'] ?? '',
                mode: widget.mode,
                subMode: item['subMode'] ?? (widget.subMode ?? ''),
                lockId: item['lockId'] ?? '',
                lockName: item['lockName'] ?? '',
                lockLocation: item['lockLocation'] ?? '',
                role: item['role'] ?? '',
                name: concatenateNameAndSurname(
                    item['userName'] ?? '', item['userSurname'] ?? ''),
                number: item['amount'] ?? 0,
                onDeleteAllNotification: (lockId) =>
                    deleteAllNotificationWarning(lockId),
                onDeclineInvitation: (notiId) => declineInvitation(notiId),
                onAcceptAllRequest: (lockId, expireDatetime) =>
                    acceptAllRequest(lockId, expireDatetime),
                onDeclineRemoval: (lockId) => declineRemoval(lockId),
                onAcceptRemoval: (lockId) => acceptRemoval(lockId),
              ),
              SizedBox(
                height: responsive.heightScale(10),
              )
            ],
          );
        },
      );
    }
  }
}
