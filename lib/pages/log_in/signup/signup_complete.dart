import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/log_in/login_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpComplete extends StatelessWidget {
  const SignUpComplete({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Background(
        appBar: AppBar(
          centerTitle: true,
          title: Label(
            size: 'xxl',
            label: 'Sign Up',
            isShadow: true,
          ),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SvgPicture.asset('assets/svg/approved.svg',
                  semanticsLabel: 'document approved',
                  height: responsive.heightScale(175)),
              SizedBox(
                height: responsive.heightScale(20),
              ),
              Label(
                  size: 'xl',
                  isBold: true,
                  label: 'Huzzah! Verification complete'),
              SizedBox(
                height: responsive.heightScale(15),
              ),
              Label(
                  size: 'xs',
                  isCenter: true,
                  label:
                      'You\'ve officially proven you\'re not a robot\n(or a squirrel trying to steal our secrets).\nNow you can unlock a world of possibilities with your smart lock!'),
              Spacer(),
              Button(onTap: () {
                Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginMain(),
                      ),
                    );
              }, label: 'Let\'s Log In'),
              SizedBox(
                height: responsive.heightScale(30),
              ),
            ],
          ),
        ));
  }
}
