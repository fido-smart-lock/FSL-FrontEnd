import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/api.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:fido_smart_lock/pages/log_in/signup/signup_email_sent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpMain extends StatefulWidget {
  const SignUpMain({super.key});

  @override
  State<SignUpMain> createState() => _SignUpMainState();
}

class _SignUpMainState extends State<SignUpMain> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;
  late TextEditingController _nameController;
  late TextEditingController _surnameController;
  late TextEditingController _emailController;
  bool _isNameValid = true;
  bool _isSurnameValid = true;
  bool _isEmailValid = true;
  bool _isPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  bool _isMoreThanEightChar = false;
  bool _isHaveUpperCase = false;
  bool _isHaveLowerCase = false;
  bool _isHaveNumber = false;
  bool _isHaveSpecialChar = false;

  final bool _isPassedPasswordRules = true;

  String _passwordValidationText = "This field is required";

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _validateAndSave() async {
    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
      _isSurnameValid = _surnameController.text.trim().isNotEmpty;
      _isEmailValid = RegExp(
              r'^[^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*@([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}$')
          .hasMatch(_emailController.text.trim());
      _isPasswordValid =
          _passwordController.text.trim().isNotEmpty && _isPassedPasswordRules;
      _isConfirmPasswordValid =
          _confirmPasswordController.text.trim().isNotEmpty &&
              (_confirmPasswordController.text.trim() ==
                  _passwordController.text.trim());
    });

    if (_isNameValid &&
        _isSurnameValid &&
        _isEmailValid &&
        _isPasswordValid &&
        _isConfirmPasswordValid) {
      await createAccount(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignUpEmailSent(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _surnameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _nameController.addListener(() {
      setState(() {
        _isNameValid = _nameController.text.trim().isNotEmpty;
      });
    });

    _surnameController.addListener(() {
      setState(() {
        _isSurnameValid = _surnameController.text.trim().isNotEmpty;
      });
    });

    _emailController.addListener(() {
      setState(() {
        _isEmailValid = RegExp(
                r'^[^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*@([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}$')
            .hasMatch(_emailController.text.trim());
      });
    });

    _passwordController.addListener(() {
      setState(() {
        _isMoreThanEightChar = _passwordController.text.trim().length >= 8;
        _isHaveUpperCase =
            _passwordController.text.trim().contains(RegExp(r'[A-Z]'));
        _isHaveLowerCase =
            _passwordController.text.trim().contains(RegExp(r'[a-z]'));
        _isHaveNumber = _passwordController.text.trim().contains(RegExp(r'\d'));
        _isHaveSpecialChar =
            _passwordController.text.trim().contains(RegExp(r'[!@#\$&*~]'));

        _isPasswordValid = _isMoreThanEightChar &&
            _isHaveUpperCase &&
            _isHaveLowerCase &&
            _isHaveNumber &&
            _isHaveSpecialChar;

        _passwordValidationText = _getPasswordValidationMessage();
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        _isConfirmPasswordValid =
            _confirmPasswordController.text.trim().isNotEmpty &&
                (_confirmPasswordController.text.trim() ==
                    _passwordController.text.trim());
      });
    });
  }

  Future<void> createAccount(BuildContext context) async {
    try {
      final body = {
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
        'firstName': _nameController.text.trim(), // Default empty string
        'lastName': _surnameController.text.trim(),
        'userImage': '',
      };

      // ignore: unused_local_variable
      final response = await postJsonData(
        apiUri: 'https://fsl-1080584581311.us-central1.run.app/signup',
        body: body,
      );
    } catch (e) {
      RegExp regExp = RegExp(r'(\d{3})'); // Matches three digits (e.g., 409)
      String? statusCode = regExp.stringMatch(e.toString());

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

  String _getPasswordValidationMessage() {
    if (!_isMoreThanEightChar) {
      return "Password must be at least 8 characters long.";
    } else if (!_isHaveUpperCase) {
      return "Password must contain uppercase letter.";
    } else if (!_isHaveLowerCase) {
      return "Password must contain lowercase letter.";
    } else if (!_isHaveNumber) {
      return "Password must contain number.";
    } else if (!_isHaveSpecialChar) {
      return "Password must contain special character.";
    }
    return "";
  }

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
      child: Column(
        children: [
          CustomTextField(
            controller: _nameController,
            labelText: 'First Name',
            labelColor: _isNameValid ? Colors.white : Colors.red,
            isValid: _isNameValid,
          ),
          CustomTextField(
            controller: _surnameController,
            labelText: 'Last Name',
            labelColor: _isSurnameValid ? Colors.white : Colors.red,
            isValid: _isNameValid,
          ),
          SizedBox(
            height: responsive.heightScale(15),
          ),
          CustomTextField(
              controller: _emailController,
              labelText: 'Email',
              labelColor: _isEmailValid ? Colors.white : Colors.red,
              mode: 'verified',
              isValid: _isEmailValid,
              validateText: "please fill the correct email."),
          CustomTextField(
            controller: _passwordController,
            labelText: 'Enter password',
            labelColor: _isPasswordValid ? Colors.white : Colors.red,
            mode: 'password',
            isValid: _isPasswordValid,
            validateText: _passwordValidationText,
          ),
          SizedBox(
            height: responsive.heightScale(15),
          ),
          CustomTextField(
            controller: _confirmPasswordController,
            labelText: 'Reenter password',
            labelColor: _isConfirmPasswordValid ? Colors.white : Colors.red,
            mode: 'password',
            isValid: _isConfirmPasswordValid,
            validateText: 'Passwords do not match.',
          ),
          SizedBox(
            height: responsive.heightScale(185),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Button(
              onTap: _validateAndSave,
              label: 'Sign Up',
            ),
          ),
          Label(
            size: 'xs',
            isCenter: true,
            label:
                'By selecting Sign up, I agree to Terms of Service & Privacy Policy',
            color: Colors.grey,
          ),
          SizedBox(
            height: responsive.heightScale(20),
          ),
        ],
      ),
    );
  }
}
