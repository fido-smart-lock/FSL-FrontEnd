import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';
import 'dart:convert'; // For JSON parsing
import 'package:flutter/services.dart'; // For loading asset data

import 'package:fido_smart_lock/component/card/noti_card.dart';

class TabBarContents extends StatelessWidget {
  const TabBarContents({super.key, required this.mode});

  final String mode;

  Future<List<Map<String, dynamic>>> _loadData() async {
    // Load the JSON file from assets
    final String response = await rootBundle.loadString('assets/data/noti_$mode.json');
    final List<dynamic> data = json.decode(response);
    
    // Convert dynamic list to List<Map<String, dynamic>>
    return data.map((item) => item as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No notifications available'));
        } else {
          // Build the ListView
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              // Get each item data from the parsed JSON
              final item = snapshot.data![index];

              return Column(
                children: [
                  NotiCard(
                    dateTime: item['dateTime'] ?? '',
                    mode: mode,
                    subMode: item['subMode'] ?? '',
                    lockName: item['lockName'] ?? '',
                    lockLocation: item['lockLocation'] ?? '',
                    role: item['role'] ?? '',
                    name: item['name'] ?? '',
                    number: item['number'] ?? 0,
                  ),
                  SizedBox(height: responsive.heightScale(10),)
                ],
              );
            },
          );
        }
      },
    );
  }
}
