import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/card/noti_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON decoding
import 'package:flutter/services.dart'; // For loading asset data

class WarningView extends StatelessWidget {
  const WarningView({
    super.key,
    required this.lockLocation,
    required this.lockName,
  });

  final String lockLocation;
  final String lockName;
  static const mode = 'warning';
  static const subMode = 'view';

  // Method to load and parse JSON data
  Future<List<Map<String, dynamic>>> _loadRiskData() async {
    final String response = await rootBundle.loadString('assets/data/noti_risk_attempt.json');
    final List<dynamic> data = json.decode(response);
    return data.map((item) => item as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
      appBar: AppBar(
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
          Label(size: 'm', label: '$lockLocation: $lockName', isBold: true,),
          SizedBox(height: responsive.heightScale(10),),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: _loadRiskData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error loading data'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No risk attempts found'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];

                      return Column(
                        children: [
                          NotiCard(
                            dateTime: item['dateTime'] ?? '',
                            mode: mode,
                            subMode: subMode,
                            error: item['error'] ?? '',
                          ),
                          SizedBox(
                            height: responsive.heightScale(10),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
