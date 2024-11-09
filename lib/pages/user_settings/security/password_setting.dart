import 'package:fido_smart_lock/component/background/background.dart';
import 'package:fido_smart_lock/component/button.dart';
import 'package:fido_smart_lock/component/input/textfield_input.dart';
import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';

class PasswordSetting extends StatefulWidget {
  const PasswordSetting({super.key});

  @override
  State<PasswordSetting> createState() => _PasswordSettingState();
}

class _PasswordSettingState extends State<PasswordSetting> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _isCurrentPasswordValid = true;
  bool _isNewPasswordValid = true;
  bool _isConfirmPasswordValid = true;

  bool _isMoreThanEightChar = false;
  bool _isHaveUpperCase = false;
  bool _isHaveLowerCase = false;
  bool _isHaveNumber = false;
  bool _isHaveSpecialChar = false;

  final bool _isPassedPasswordRules = true;

  String _newPasswordValidationText = "";

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _validateAndSave() {
    setState(() {
      _isCurrentPasswordValid =
          _currentPasswordController.text.trim().isNotEmpty;
      _isNewPasswordValid = _newPasswordController.text.trim().isNotEmpty &&
          _isPassedPasswordRules;
      _isConfirmPasswordValid =
          _confirmPasswordController.text.trim().isNotEmpty &&
              (_confirmPasswordController.text.trim() ==
                  _newPasswordController.text.trim());
    });

    if (_isCurrentPasswordValid &&
        _isNewPasswordValid &&
        _isConfirmPasswordValid) {
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _currentPasswordController.addListener(() {
      setState(() {
        _isCurrentPasswordValid =
            _currentPasswordController.text.trim().isNotEmpty;
      });
    });

    _newPasswordController.addListener(() {
      setState(() {
        _isMoreThanEightChar = _newPasswordController.text.trim().length >= 8;
        _isHaveUpperCase =
            _newPasswordController.text.trim().contains(RegExp(r'[A-Z]'));
        _isHaveLowerCase =
            _newPasswordController.text.trim().contains(RegExp(r'[a-z]'));
        _isHaveNumber =
            _newPasswordController.text.trim().contains(RegExp(r'\d'));
        _isHaveSpecialChar =
            _newPasswordController.text.trim().contains(RegExp(r'[!@#\$&*~]'));

        _isNewPasswordValid = _isMoreThanEightChar &&
            _isHaveUpperCase &&
            _isHaveLowerCase &&
            _isHaveNumber &&
            _isHaveSpecialChar;

        _newPasswordValidationText = _getPasswordValidationMessage();
      });
    });

    _confirmPasswordController.addListener(() {
      setState(() {
        _isConfirmPasswordValid =
            _confirmPasswordController.text.trim().isNotEmpty &&
                (_confirmPasswordController.text.trim() ==
                    _newPasswordController.text.trim());
      });
    });
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
    return ""; // No error message if all conditions are met
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Background(
      appBar: AppBar(
        title: Label(
          size: 'xxl',
          label: 'Change Password',
          isShadow: true,
        ),
      ),
      child: Column(
        children: [
          CustomTextField(
            controller: _currentPasswordController,
            labelText: 'Enter current password',
            labelColor: _isCurrentPasswordValid ? Colors.grey : Colors.red,
            mode: 'password',
            isValid: _isCurrentPasswordValid,
            validateText: 'Please enter your current password.',
          ),
          SizedBox(
            height: responsive.heightScale(30),
          ),
          CustomTextField(
            controller: _newPasswordController,
            labelText: 'Enter new password',
            labelColor: _isNewPasswordValid ? Colors.grey : Colors.red,
            mode: 'password',
            isValid: _isNewPasswordValid,
            validateText: _newPasswordValidationText,
          ),
          SizedBox(
            height: responsive.heightScale(15),
          ),
          CustomTextField(
            controller: _confirmPasswordController,
            labelText: 'Reenter new password',
            labelColor: _isConfirmPasswordValid ? Colors.grey : Colors.red,
            mode: 'password',
            isValid: _isConfirmPasswordValid,
            validateText: 'Passwords do not match.',
          ),
          SizedBox(
            height: responsive.heightScale(20),
          ),
          Spacer(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Button(
              onTap: _validateAndSave,
              label: 'Save Change',
            ),
          ),
        ],
      ),
    );
  }
}
