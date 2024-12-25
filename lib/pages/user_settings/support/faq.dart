import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/dropdown/faq_dropdown.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/pages/user_settings/support/support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'faq_list.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(CupertinoIcons.left_chevron),
            onPressed: () {
              // Navigate to Support page when back button is pressed
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Support()),
              );
            },
          ),
          title: Label(
            size: 'xxl',
            label: 'FAQ',
            isShadow: true,
          ),
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
              children: faqDataList.entries.map((entry) {
            // For each entry, get the question and answer Column widget
            String question = entry.value['question'] as String;
            Widget answer = entry.value['answer'] as Widget;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [FaqDropdown(question: question, answer: answer)],
            );
          }).toList()),
        ));
  }
}
