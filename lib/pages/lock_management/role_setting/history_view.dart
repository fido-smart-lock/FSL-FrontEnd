import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/person_card.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For loading asset data
import 'dart:convert'; // For JSON parsing

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  late String lockName;
  late String lockLocation;
  late List<String> img;
  late List<String> dateTime;
  late List<String> name;
  late List<String> status;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final String response = await rootBundle.loadString('assets/data/lock_detail_history.json');
    final Map<String, dynamic> data = json.decode(response);

    setState(() {
      lockName = data['lockName'];
      lockLocation = data['lockLocation'];
      img = (data['history'] as List).map((item) => item['img'] as String).toList();
      dateTime = (data['history'] as List).map((item) => item['dateTime'] as String).toList();
      name = (data['history'] as List).map((item) => item['name'] as String).toList();
      status = (data['history'] as List).map((item) => item['status'] as String).toList();
    });
  }

  bool _isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    DateTime now = DateTime.now().subtract(const Duration(days: 1));
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    // Convert dateTime strings to DateTime objects for comparison
    List<DateTime> dateTimes = dateTime.map((dt) => DateTime.parse(dt)).toList();

    // Split items into categories: Today, Yesterday, and Earlier
    List<int> todayIndices = [];
    List<int> yesterdayIndices = [];
    List<int> earlierIndices = [];

    for (int i = 0; i < dateTimes.length; i++) {
      if (_isToday(dateTimes[i])) {
        todayIndices.add(i);
      } else if (_isYesterday(dateTimes[i])) {
        yesterdayIndices.add(i);
      } else {
        earlierIndices.add(i);
      }
    }

    final responsive = Responsive(context);

    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              size: 'xxl',
              label: lockName,
              isShadow: true,
            ),
            Label(
              size: 'l',
              label: lockLocation,
              color: Colors.grey.shade300,
              isShadow: true,
            ),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(
            size: 'xl',
            label: 'History',
            isBold: true,
          ),
          Expanded(
            child: ListView(
              children: [
                if (todayIndices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        size: 's',
                        label: 'Today',
                        isBold: true,
                      ),
                      ...todayIndices.map((index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: PersonHistoryCard(
                              img: img[index],
                              name: name[index],
                              status: status[index],
                              dateTime: dateTime[index],
                            ),
                          )),
                      SizedBox(height: responsive.heightScale(25)),
                    ],
                  ),
                if (yesterdayIndices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        size: 's',
                        label: 'Yesterday',
                        isBold: true,
                      ),
                      ...yesterdayIndices.map((index) => Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: PersonHistoryCard(
                              img: img[index],
                              name: name[index],
                              status: status[index],
                              dateTime: dateTime[index],
                            ),
                          )),
                      SizedBox(height: responsive.heightScale(25)),
                    ],
                  ),
                if (earlierIndices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Label(
                        size: 's',
                        label: 'Earlier',
                        isBold: true,
                      ),
                      ...earlierIndices.map((index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: PersonHistoryCard(
                            img: img[index],
                            name: name[index],
                            status: status[index],
                            dateTime: dateTime[index],
                          ),
                        );
                      }),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
