import 'package:corbado_auth/corbado_auth.dart';
import 'package:fido_smart_lock/auth_provider.dart';
import 'package:fido_smart_lock/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorage();
  final projectId = 'pro-5201720496569808831';
  final customDomain = 'https://$projectId.frontendapi.cloud.corbado.io';
  final corbadoAuth = CorbadoAuth();

  // Perform initialization
  await corbadoAuth.init(projectId: projectId, customDomain: customDomain);

  // Check if user is logged in
  String? userId = await storage.read(key: 'userId');

  runApp(ProviderScope(
    overrides: [
      corbadoProvider.overrideWithValue(corbadoAuth),
    ],
    child: MyApp(isLoggedIn: userId != null),
  ));
}

class MyApp extends ConsumerWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Fido Smart-Lock',
      theme: _buildTheme(Brightness.dark),
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      builder: (context, child) {
        return child!;
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
