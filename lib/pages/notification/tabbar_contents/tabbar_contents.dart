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
          debugPrint('Data: $dataList');
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
