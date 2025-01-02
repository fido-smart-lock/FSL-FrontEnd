import 'package:fido_smart_lock/pages/home.dart';
import 'package:fido_smart_lock/pages/log_in/login_main.dart';
import 'package:fido_smart_lock/pages/user_settings/support/faq.dart';
import 'package:fido_smart_lock/pages/user_settings/support/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorage();
  String? userId = await storage.read(key: 'userId'); // Check if user is logged in

  runApp(MyApp(isLoggedIn: userId != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fido Smart-Lock',
      theme: _buildTheme(Brightness.dark),
      home: isLoggedIn ? Home() : LoginMain(),
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