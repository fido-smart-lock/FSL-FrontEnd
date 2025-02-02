import 'package:fido_smart_lock/component/background/background.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(child: Center(child: CircularProgressIndicator()));
  }
}
