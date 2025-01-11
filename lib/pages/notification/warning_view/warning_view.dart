import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/card/noti_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';

class WarningView extends StatefulWidget {
  const WarningView({
    super.key,
    required this.lockId,
    required this.lockName,
    required this.lockLocation,
  });

  final String lockId;
  final String lockName;
  final String lockLocation;
  static const mode = 'warning';
  static const subMode = 'view';

  @override
  State<WarningView> createState() => _WarningViewState();
}

class _WarningViewState extends State<WarningView> {
  List<Map<String, dynamic>>? dataList = [];
  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchUserNotification();
  }

  Future<void> fetchUserNotification() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/notification/warning/view/$userId/${widget.lockId}';

      try {
        var data = await getJsonData(apiUri: apiUri);
        setState(() {
          isDataLoaded = true;
          dataList = List<Map<String, dynamic>>.from(data['dataList']);
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

  Future<void> deleteNotificationWarning(String notiId) async {
    final apiUri =
        'https://fsl-1080584581311.us-central1.run.app/delete/notification/warning/${widget.lockId}/$notiId';

    try {
      final response = await deleteJsonData(apiUri: apiUri);
      debugPrint('Delete successful: $response');
      await fetchUserNotification();
    } catch (e) {
      debugPrint('Error deleting notification warning: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Label(
          size: 'xl',
          label: 'View all risk attempts',
          isBold: true,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            size: 'm',
            label: '${widget.lockLocation}: ${widget.lockName}',
            isBold: true,
          ),
          SizedBox(
            height: responsive.heightScale(10),
          ),
          if (!isDataLoaded) ...[
            Expanded(child: Center(child: CircularProgressIndicator())),
          ] else if (dataList!.isEmpty) ...[
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    SvgPicture.asset('assets/svg/restSecurity.svg',
                        semanticsLabel: 'Empty State',
                        height: responsive.heightScale(150)),
                    SizedBox(
                      height: 20,
                    ),
                    Label(
                      size: 's',
                      label: 'Everything in this lock looks secure!',
                      isBold: true,
                      color: Colors.grey,
                      isCenter: true,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Label(
                      size: 'xs',
                      label:
                          'sit back and relax,we will tell you if \'things\' happen.',
                      isCenter: true,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: ListView.builder(
                itemCount: dataList?.length ?? 0,
                itemBuilder: (context, index) {
                  final item = dataList![index];

                  return Column(
                    children: [
                      NotiCard(
                          notiId: item['notiId'] ?? '',
                          dateTime: item['dateTime'] ?? '',
                          mode: WarningView.mode,
                          subMode: WarningView.subMode,
                          error: item['error'] ?? '',
                          lockId: item['lockId'] ?? '',
                          onDeleteNotification: (notiId) =>
                              deleteNotificationWarning(notiId)),
                      SizedBox(
                        height: responsive.heightScale(10),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
