import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/component/card/person_card.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key, required this.lockId});

  final String lockId;

  @override
  _HistoryViewState createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  String? lockName;
  String? lockLocation;
  List<Map<String, dynamic>>? dataList;

  @override
  void initState() {
    super.initState();
    fetchLockHistory();
  }

  Future<void> fetchLockHistory() async {
    String apiUri =
        'https://fsl-1080584581311.us-central1.run.app/history/${widget.lockId}';

    try {
      var data = await getJsonData(apiUri: apiUri)
          .timeout(const Duration(seconds: 10));
      debugPrint('API Response: ${data.toString()}');

      setState(() {
        lockLocation = data['lockLocation'] ?? 'Unknown Location';
        lockName = data['lockName'] ?? 'Unknown Lock';
        dataList = data['dataList'] != null && data['dataList'] is List
            ? List<Map<String, dynamic>>.from(data['dataList'])
            : [];
      });
    } catch (e) {
      debugPrint('Error: $e');
      setState(() {
        lockLocation = null;
        lockName = null;
        dataList = null;
      });
    }
  }

  bool _isToday(DateTime date) {
    DateTime now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  bool _isYesterday(DateTime date) {
    DateTime now = DateTime.now().subtract(const Duration(days: 1));
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (dataList == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Label(size: 'm', label: 'Fetching history... Please wait.')
          ],
        ),
      );
    }

    if (dataList!.isEmpty) {
      return Background(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Label(
                size: 'xxl',
                label: lockName ?? 'Loading...',
                isShadow: true,
              ),
              Label(
                size: 'l',
                label: lockLocation ?? 'Loading...',
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      width: responsive.widthScale(200),
                      height: responsive.heightScale(200),
                    child: Image.network('https://i.postimg.cc/ncPjMvKy/svgviewer-png-output.png')),
                  const SizedBox(
                    height: 20,
                  ),
                  const Label(
                    size: 'm',
                    label: 'Nothing to see here (yet).',
                    isBold: true,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Label(
                    size: 'm',
                    label:
                        'using windows is maybe not the best way to get out of your property',
                    isCenter: true,
                    color: Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    List<int> todayIndices = [];
    List<int> yesterdayIndices = [];
    List<int> earlierIndices = [];

    for (int i = 0; i < dataList!.length; i++) {
      DateTime date = DateTime.parse(dataList![i]['dateTime']);
      if (_isToday(date)) {
        todayIndices.add(i);
      } else if (_isYesterday(date)) {
        yesterdayIndices.add(i);
      } else {
        earlierIndices.add(i);
      }
    }

    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Label(
              size: 'xxl',
              label: lockName ?? 'Loading...',
              isShadow: true,
            ),
            Label(
              size: 'l',
              label: lockLocation ?? 'Loading...',
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
            child: ListView.builder(
              itemCount: dataList!.length,
              itemBuilder: (context, index) {
                DateTime date = DateTime.parse(dataList![index]['dateTime']);
                String title = _isToday(date)
                    ? 'Today'
                    : _isYesterday(date)
                        ? 'Yesterday'
                        : 'Earlier';
                return _buildHistorySection(
                  title: title,
                  indices: [index],
                  responsive: responsive,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection({
    required String title,
    required List<int> indices,
    required Responsive responsive,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Label(
          size: 's',
          label: title,
          isBold: true,
        ),
        ...indices.map((index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 2.5),
              child: PersonHistoryCard(
                img: dataList![index]['userImage'] ??
                    'https://via.placeholder.com/150',
                name: dataList![index]['userName'] ?? 'Unknown',
                status: dataList![index]['status'] ?? 'Unknown',
                dateTime: dataList![index]['dateTime'],
              ),
            )),
        SizedBox(height: responsive.heightScale(25)),
      ],
    );
  }
}
