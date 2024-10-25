import 'package:fido_smart_lock/component/label.dart';
import 'package:fido_smart_lock/helper/size.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final int maxLength;
  final String labelText;
  final TextEditingController controller;
  final Color labelColor;

  const CustomTextField({
    super.key,
    required this.maxLength,
    required this.controller,
    required this.labelText,
    required this.labelColor,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late FocusNode _focusNode;
  String _currentText = '';

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
    double responsiveFontSize = MediaQuery.of(context).size.width * 0.03;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Stack(
        children: [
          TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            maxLength: widget.maxLength,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: TextStyle(
                color: widget.labelColor,
                fontSize: 20,
              ),
              counterText: '',
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: responsiveFontSize * 0.5,
            child: AnimatedOpacity(
              opacity:
                  _focusNode.hasFocus || _currentText.isNotEmpty ? 1.0 : 0.0,
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
              color: Colors.blueGrey[900],
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
        SizedBox(width: responsive.widthScale(5),),
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
          child: Label(label: 'Find',),
        ),
      ],
    );
  }
}
