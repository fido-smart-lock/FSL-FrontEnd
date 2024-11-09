import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/dropdown/faq_dropdown.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:flutter/material.dart';
import 'faq_list.dart';

class Faq extends StatelessWidget {
  const Faq({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
        appBar: AppBar(
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
              children: [
                FaqDropdown(question: question, answer: answer)
              ],
            );
          }).toList()
          ),
        ));
  }
}
