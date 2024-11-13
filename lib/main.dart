import 'package:fido_smart_lock/pages/home.dart';
import 'package:fido_smart_lock/pages/user_settings/support/faq.dart';
import 'package:fido_smart_lock/pages/user_settings/support/support.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fido Smart-Lock',
      theme: _buildTheme(Brightness.dark),
      home: Home(),
      initialRoute: '/',
      routes: {
        '/home': (context) => Home(initialIndex: 0),
        '/support': (context) => Support(),
        'faq': (context) => Faq()
        // add other routes here
      },
    );
  }

  ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);

  return baseTheme.copyWith(
    textTheme: GoogleFonts.promptTextTheme(baseTheme.textTheme),
  );
}

}