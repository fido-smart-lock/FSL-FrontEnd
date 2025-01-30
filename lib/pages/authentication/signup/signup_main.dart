// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/helper/word.dart';
import 'package:flutter/material.dart';
import 'package:corbado_auth/corbado_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SignUpMain extends HookWidget implements CorbadoScreen<SignupInitBlock> {
  @override
  final SignupInitBlock block;

  const SignUpMain(this.block);

  Future<void> _validateAndSave(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController surnameController,
    TextEditingController emailController,
    ValueNotifier<bool> isNameValid,
    ValueNotifier<bool> isSurnameValid,
    ValueNotifier<bool> isEmailValid,
  ) async {
    final name = nameController.text.trim();
    final surname = surnameController.text.trim();
    final email = emailController.text.trim();

    isNameValid.value = name.isNotEmpty;
    isSurnameValid.value = surname.isNotEmpty;
    isEmailValid.value = RegExp(
      r'^[^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*@([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}$',
    ).hasMatch(email);

    if (isNameValid.value && isSurnameValid.value && isEmailValid.value) {
      await createAccount(context, email, name, surname);
    }
  }

  Future<void> createAccount(
    BuildContext context,
    String email,
    String firstName,
    String lastName,
  ) async {
    final fullName = concatenateNameAndSurname(firstName, lastName);

    try {
      final body = {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userImage': '',
      };

      await block.submitSignupInit(email: email, fullName: fullName);

      await postJsonData(
        apiUri: 'https://fsl-1080584581311.us-central1.run.app/signup',
        body: body,
      );
    } catch (e) {
      final regExp = RegExp(r'(\d{3})');
      final statusCode = regExp.stringMatch(e.toString());

      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Oh no!',
          message:
              'Something went wrong, please try again. status code $statusCode',
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
    final email = block.data.email;

    final nameController = useTextEditingController();
    final surnameController = useTextEditingController();
    final emailController = useTextEditingController(text: email?.value);

    final isNameValid = useState(true);
    final isSurnameValid = useState(true);
    final isEmailValid = useState(true);

    final responsive = Responsive(context);

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final maybeError = block.error;
        if (maybeError != null) {
          debugPrint('Error: ${maybeError.detailedError()}');
        }
      });
    }, [block.error]);

    return Background(
      appBar: AppBar(
        centerTitle: true,
        title: Label(
          size: 'xxl',
          label: 'Sign Up',
          isShadow: true,
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: responsive.widthScale(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: nameController,
                labelText: 'First Name',
                labelColor: isNameValid.value ? Colors.white : Colors.red,
                isValid: isNameValid.value,
              ),
              CustomTextField(
                controller: surnameController,
                labelText: 'Last Name',
                labelColor: isSurnameValid.value ? Colors.white : Colors.red,
                isValid: isSurnameValid.value,
              ),
              SizedBox(height: responsive.heightScale(15)),
              CustomTextField(
                controller: emailController,
                labelText: 'Email',
                labelColor: isEmailValid.value ? Colors.white : Colors.red,
                mode: 'verified',
                isValid: isEmailValid.value,
                validateText: 'Please fill in a correct email.',
              ),
              SizedBox(height: responsive.heightScale(200)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Button(
                  onTap: () => _validateAndSave(
                    context,
                    nameController,
                    surnameController,
                    emailController,
                    isNameValid,
                    isSurnameValid,
                    isEmailValid,
                  ),
                  label: 'Sign Up',
                ),
              ),
              SizedBox(height: responsive.heightScale(15)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Label(size: 's', label: 'so we know you?'),
                  SizedBox(
                    width: responsive.widthScale(5),
                  ),
                  GestureDetector(
                    onTap: () {
                      debugPrint('Navigate to login');
                      block.navigateToLogin();
                    },
                    child: Label(
                      size: 's',
                      isUnderlined: true,
                      isBold: true,
                      label: 'Log in',
                    ),
                  ),
                ],
              ),
              SizedBox(height: responsive.heightScale(20)),
            ],
          ),
        ),
      ),
    );
  }
}
