import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/log_in/signup/signup_complete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpEmailSent extends StatelessWidget {
  const SignUpEmailSent({super.key});

  static const email = 'jonathan.s@example.com';

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
              SvgPicture.asset('assets/svg/dreamMail.svg',
                  semanticsLabel: 'man dreaming about email',
                  height: responsive.heightScale(175)),
              SizedBox(
                height: responsive.heightScale(20),
              ),
              Label(
                  size: 'xl',
                  isBold: true,
                  label: 'Welcome to the club (almost)!'),
              SizedBox(
                height: responsive.heightScale(15),
              ),
              Label(
                  size: 'xs',
                  isCenter: true,
                  label:
                      'We sent a verification email to $email \nClick the link in the email (check spam too!) and ready to unlock some smart lock magic!'),
              Spacer(),
              Button(onTap: () {
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpComplete(),
                      ),
                    );
              }, label: 'Yay!'),
              SizedBox(
                height: responsive.heightScale(15),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Label(size: 's', label: 'Doesn\'t get the email?'),
                  SizedBox(
                    width: responsive.widthScale(5),
                  ),
                  GestureDetector(
                      onTap: () {
                        //TODO: add resend email
                      },
                      child: Label(
                          size: 's',
                          isUnderlined: true,
                          isBold: true,
                          label: 'Resend')),
                ],
              ),
              SizedBox(
                height: responsive.heightScale(30),
              ),
            ],
          ),
        ));
  }
}
