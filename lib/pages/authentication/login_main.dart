// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:corbado_auth/corbado_auth.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginMain extends HookWidget implements CorbadoScreen<LoginInitBlock> {
  @override
  final LoginInitBlock block;

  LoginMain(this.block);

  final storage = FlutterSecureStorage();

  Future<void> _onLogIn(TextEditingController emailController,
      ValueNotifier<bool> isEmailValid, BuildContext context) async {
    isEmailValid.value = RegExp(
            r'^[^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*@([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}$')
        .hasMatch(emailController.text.trim());

    if (isEmailValid.value) {
      await logIn(emailController.text.trim(), context);
    }
  }

  Future<void> logIn(String email, BuildContext context) async {
    try {
      final responseBody = await postJsonDataWithoutBody(
        apiUri: 'https://fsl-1080584581311.us-central1.run.app/login/$email',
      );

      if (responseBody != null && responseBody.isNotEmpty) {
        String userId = responseBody['userId'];
        int userCode = responseBody['userCode'];

        debugPrint('$userId, $userCode');

        await storage.write(key: 'userId', value: userId);
        await storage.write(key: 'userCode', value: userCode.toString());

        await block.submitLogin(loginIdentifier: email);

      } else {
        throw Exception("Empty response body");
      }
    } catch (e) {
      debugPrint('$e');
      RegExp regExp = RegExp(r'(\d{3})');
      String? statusCode = regExp.stringMatch(e.toString());

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Oh no!',
          message:
              'Something went wrong, please try again. Status code $statusCode',
          contentType: ContentType.failure,
        ),
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    // Using hooks for state
    final emailController = useTextEditingController();
    final isEmailValid = useState(true);

    // Listen to controller changes
    useEffect(() {
      void emailListener() {
        isEmailValid.value = emailController.text.trim().isNotEmpty;
      }

      emailController.addListener(emailListener);

      return () {
        emailController.removeListener(emailListener);
      };
    }, [emailController]);
 
    return Background(
      child: SingleChildScrollView(
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
        
              // Form fields
              CustomTextField(
                  controller: emailController,
                  labelText: 'Email',
                  labelColor: isEmailValid.value ? Colors.white : Colors.red,
                  isValid: isEmailValid.value,
                  validateText: 'Please enter your email.'),
        
              // Login button and register option
              SizedBox(
                height: responsive.heightScale(100),
              ),
              Button(
                onTap: () => _onLogIn(emailController, isEmailValid, context),
                label: 'Log In',
              ),
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
                      
                      block.navigateToSignup();
                    },
                    child: Label(
                        size: 's',
                        isUnderlined: true,
                        isBold: true,
                        label: 'Sign up'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
