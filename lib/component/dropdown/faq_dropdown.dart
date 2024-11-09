import 'package:fido_smart_lock/component/label.dart';
import 'package:flutter/material.dart';

class FaqDropdown extends StatelessWidget {
  const FaqDropdown({super.key, required this.question, required this.answer});

  final String question;
  final Widget answer;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(10)
      ),
      child: ExpansionTile(
        title: Label(size: 'm', label: question),
        children: [
          Column(children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.grey[850], borderRadius: BorderRadius.circular(10)),
              child: answer),
          ])
        ],
      ),
    );
  }
}
