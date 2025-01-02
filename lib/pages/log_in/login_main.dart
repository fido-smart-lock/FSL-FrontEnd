import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/home.dart';
import 'package:fido_smart_lock/pages/log_in/signup/signup_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginMain extends StatefulWidget {
  const LoginMain({super.key});

  @override
  State<LoginMain> createState() => _LoginMainState();
}

class _LoginMainState extends State<LoginMain> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isPasswordValid = true;
  bool _isEmailValid = true;
  final storage = FlutterSecureStorage();

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _onLogIn() async {
    setState(() {
      _isPasswordValid = _passwordController.text.trim().isNotEmpty;
      _isEmailValid = RegExp(
              r'^[^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*@([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}$')
          .hasMatch(_emailController.text.trim());
    });

    if (_isEmailValid && _isPasswordValid){
      // Hardcoded userId
            String userId = "bs2623";
            int userCode = 3390; //TODO: Replace with API call once ready
            await storage.write(key: 'userId', value: userId);
            await storage.write(key: 'userCode', value: userCode.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(initialIndex: 0),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    _passwordController.addListener(() {
      setState(() {
        _isPasswordValid = _passwordController.text.trim().isNotEmpty;
      });
    });

    _emailController.addListener(() {
      setState(() {
        _isEmailValid = _emailController.text.trim().isNotEmpty;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
        child: Align(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          SvgPicture.asset('assets/svg/knight.svg',
              semanticsLabel: 'security knight protecting the phone',
              height: responsive.heightScale(175)),
          SizedBox(
            height: responsive.heightScale(20),
          ),
          Label(size: 'xxl', isBold: true, label: 'Welcome back!'),
          SizedBox(
            height: responsive.heightScale(15),
          ),
          Label(
              size: 's',
              isCenter: true,
              label: 'Just making sure it\'s you...\nSpill the beans!'),
          SizedBox(
            height: responsive.heightScale(20),
          ),

          //form field
          CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              labelColor: _isEmailValid ? Colors.white : Colors.red,
              isValid: _isEmailValid,
              validateText: 'Please enter your email.'),
          CustomTextField(
            controller: _passwordController,
            labelText: 'Password',
            labelColor: _isPasswordValid ? Colors.white : Colors.red,
            mode: 'password',
            isValid: _isPasswordValid,
            validateText: 'Please enter your password.',
          ),

          //Login button and register option
          SizedBox(
            height: responsive.heightScale(100),
          ),
          Button(onTap: _onLogIn, label: 'Log In'),
          SizedBox(
            height: responsive.heightScale(5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Label(size: 's', label: 'so we don\'t know you?'),
              SizedBox(
                width: responsive.widthScale(5),
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpMain(),
                      ),
                    );
                  },
                  child: Label(
                      size: 's',
                      isUnderlined: true,
                      isBold: true,
                      label: 'Sign up')),
            ],
          ),
        ],
      ),
    ));
  }
}
