import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final int maxLength;
  final String labelText;
  final void Function(String newName) onChanged;

  const CustomTextField({
    super.key,
    required this.maxLength,
    required this.onChanged,
    required this.labelText,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(_updateText);
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _updateText() {
    setState(() {
      _currentText = _controller.text;
    });
    widget.onChanged(_currentText);
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
            controller: _controller,
            focusNode: _focusNode,
            maxLength: widget.maxLength,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              labelText: widget.labelText,
              labelStyle: TextStyle(
                  color: _focusNode.hasFocus ? Colors.grey[300] : Colors.white,
                  fontSize: _focusNode.hasFocus ? 20 : 20),
              counterText: '',
              focusedBorder: UnderlineInputBorder(
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
              opacity: _focusNode.hasFocus || (_currentText.length>0) ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Text(
                '${_currentText.length}/${widget.maxLength}',
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
