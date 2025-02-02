import 'package:fido_smart_lock/auth_provider.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/card/setting_card.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/userid.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsMain extends StatefulWidget {
  const SettingsMain({super.key});

  @override
  _SettingsMainState createState() => _SettingsMainState();
}

class _SettingsMainState extends State<SettingsMain> {
  String? userName = '';
  String? userImage = '';
  String? userSurname = '';
  String? userEmail = '';
  bool? isEmailVerified = false;
  String? userCode = '';

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    const storage = FlutterSecureStorage();
    String? userId = await storage.read(key: 'userId');
    String? code = await storage.read(key: 'userCode');

    if (userId != null) {
      String apiUri =
          'https://fsl-1080584581311.us-central1.run.app/userDetail/$userId';

      try {
        var dataProfile = await getJsonData(apiUri: apiUri);
        setState(() {
          userCode = code;
          isEmailVerified = dataProfile['isEmailVerified'];
          userName = dataProfile['userName'] ?? '';
          userSurname = dataProfile['userSurname'] ?? '';
          userEmail = dataProfile['userEmail'] ?? '';
          userImage = dataProfile['userImage'] ?? '';
        });
      } catch (e) {
        debugPrint('Error: $e');
      }
    } else {
      debugPrint('User ID not found in secure storage.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Consumer(
      builder: (context, ref, _) {
        final corbado = ref.watch(corbadoProvider);

        return Background(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Label(size: 'xxl', label: 'User Setting', isBold: true),
            centerTitle: false,
            leadingWidth: NavigationToolbar.kMiddleSpacing,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () async {
                    await removeUserIdAndUserCode();
                    await corbado.signOut();
                    
                  },
                  child: Icon(
                    Icons.logout_rounded,
                    size: 30,
                    color: Colors.red,
                    shadows: <Shadow>[
                      Shadow(
                          color: Colors.black.withOpacity(0.50),
                          blurRadius: 15.0),
                    ],
                  ),
                ),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    // User profile
                    CircleAvatar(
                      backgroundImage: userImage?.isNotEmpty == true
                          ? NetworkImage(userImage!)
                          : const AssetImage('assets/default_avatar.png')
                              as ImageProvider,
                      radius: responsive.radiusScale(50),
                    ),
                    SizedBox(height: responsive.heightScale(10)),
                    Label(
                      size: 'xl',
                      label: concatenateNameAndSurname(userName!, userSurname!),
                      isBold: true,
                    ),
                    Label(size: 'xs', label: userEmail ?? ''),
                    Label(
                      size: 'xs',
                      label: 'User Code: $userCode',
                      color: Colors.grey[500],
                    ),

                    // White space divider
                    SizedBox(height: responsive.heightScale(20)),

                    // Menu list
                    SettingCard(menu: 'profile'),
                    SettingCard(menu: 'security'),
                    SettingCard(menu: 'noti'),

                    // Divider
                    const Divider(),

                    // Support
                    SettingCard(menu: 'support'),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
