import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/person_card.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({
    super.key,
    required this.lockName,
    required this.lockLocation,
    required this.img,
    required this.dateTime,
    required this.name,
    required this.status,
  });

  final String lockName;
  final String lockLocation;
  final List<String> img;
  final List<String> dateTime;
  final List<String> name;
  final List<String> status;

  bool _isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    DateTime now = DateTime.now().subtract(Duration(days: 1));
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderLabel(
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
                      SubLabel(label: 'Today', isBold: true,),
                      ...todayIndices.map((index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            PersonHistoryCard(
                              img: img[index],
                              name: name[index],
                              status: status[index],
                              dateTime: dateTime[index],
                            ),
                          ],
                        ),
                      )),
                      SizedBox(height: responsive.heightScale(25)),
                    ],
                  ),
                if (yesterdayIndices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubLabel(label: 'Yesterday', isBold: true,),
                      ...yesterdayIndices.map((index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Column(
                          children: [
                            PersonHistoryCard(
                              img: img[index],
                              name: name[index],
                              status: status[index],
                              dateTime: dateTime[index],
                            ),
                          ],
                        ),
                      )),
                      SizedBox(height: responsive.heightScale(25)),
                    ],
                  ),
                if (earlierIndices.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubLabel(label: 'Earlier', isBold: true,),
                      ...earlierIndices.map((index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: Column(
                            children: [
                              PersonHistoryCard(
                                img: img[index],
                                name: name[index],
                                status: status[index],
                                dateTime: dateTime[index],
                              ),
                            ],
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
