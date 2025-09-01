import 'package:flutter/material.dart';

class CustomRadioButton extends StatefulWidget {
  final String groupName;
  final String yesLabel;
  final String noLabel;
  final void Function(String)? onChanged;

  const CustomRadioButton({
    Key? key,
    required this.groupName,
    this.yesLabel = 'Yes',
    this.noLabel = 'No',
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  String _selectedValue = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Radio<String>(
              value: widget.noLabel,
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value!;
                  widget.onChanged?.call(value);
                });
              },
            ),
            Text(
              widget.noLabel,
              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Color(0xff334155)),

            ),
          ],
        ),
        Row(
          children: [
            Radio<String>(
              value: widget.yesLabel,
              groupValue: _selectedValue,
              onChanged: (value) {
                setState(() {
                  _selectedValue = value!;
                  widget.onChanged?.call(value);
                });
              },
            ),
            Text(
              widget.yesLabel,
              style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Color(0xff334155)),
            ),
          ],
        ),

      ],
    );
  }
}