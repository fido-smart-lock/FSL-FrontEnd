import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final int maxLength;
  final String labelText;
  final TextEditingController controller;
  final Color labelColor;
  final String mode;
  final bool isValid;
  final String validateText;

  const CustomTextField({
    super.key,
    this.maxLength = 99999,
    required this.controller,
    required this.labelText,
    required this.labelColor,
    this.mode = '',
    this.isValid = false,
    this.validateText = 'This field is required.'
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  bool _isObscured = true;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double responsiveFontSize = MediaQuery.of(context).size.width * 0.035;
    final responsive = Responsive(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Stack(
            children: [
              TextFormField(
                controller: widget.controller,
                focusNode: _focusNode,
                maxLength: widget.maxLength,
                obscureText: widget.mode == 'password' && _isObscured,
                cursorColor: widget.isValid ? Colors.grey : Colors.red,
                decoration: InputDecoration(
                  labelText: widget.labelText,
                  labelStyle: TextStyle(
                    color: widget.labelColor,
                    fontSize: 20,
                  ),
                  counterText: '',
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.isValid ? Colors.grey : Colors.red,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              if (widget.mode == 'maxLength')
                Positioned(
                  right: 0,
                  bottom: responsiveFontSize * 0.5,
                  child: AnimatedOpacity(
                    opacity: _focusNode.hasFocus || widget.controller.text.isNotEmpty ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      '${widget.controller.text.length}/${widget.maxLength}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: responsiveFontSize,
                      ),
                    ),
                  ),
                ),
              if (widget.mode == 'password')
                Positioned(
                  right: 0,
                  bottom: responsiveFontSize * 0.5,
                  child: IconButton(
                    icon: Icon(
                      _isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured; // Toggle the obscured state
                      });
                    },
                  ),
                ),
            ],
          ),
          if(!widget.isValid)
            Column(
              children: [
                SizedBox(height: responsive.heightScale(10),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.exclamationmark_triangle, color: Colors.red, size: 15,),
                  SizedBox(width: responsive.widthScale(5),),
                  Label(size: 'xs', label: widget.validateText, color: Colors.red,)
                ],
                          ),
              ],
            )
        ],
      ),
    );
  }
}
class UserCodeInput extends StatelessWidget {
  const UserCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.grey[850],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter User Code',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          width: responsive.widthScale(5),
        ),
        ElevatedButton(
          onPressed: () {
            // Add your action here
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Label(
            size: 'm',
            label: 'Find',
          ),
        ),
      ],
    );
  }
}
