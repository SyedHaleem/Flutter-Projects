import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DropDownButton extends StatefulWidget {
  final String selectedGender;
  final List<String> genders;
  final Function(String) onChanged;
  final double toppadding;

  const DropDownButton({
    Key? key,
    required this.selectedGender,
    required this.genders,
    required this.onChanged, required this.toppadding,
  }) : super(key: key);

  @override
  _DropDownButtonState createState() => _DropDownButtonState();
}

class _DropDownButtonState extends State<DropDownButton> {
  late String _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.toppadding),
      child: Container(
        width: 331,
        height: 50.79,
        decoration: BoxDecoration(color: Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(11.48),),
        child: DropdownButton<String>(
          padding: EdgeInsets.only(left: 16,right: 16),
          icon: Icon(Icons.arrow_drop_down_outlined,size: 23,color: Color(0xff5B7FFF),),
          style: GoogleFonts.nunito(fontSize: 13,color: Colors.grey),
          isExpanded: true,
          hint: Text('Select'),
          underline: SizedBox(),
          value: _selectedGender,
          onChanged: (String? newValue) {
            setState(() {
              _selectedGender = newValue!;
              widget.onChanged(newValue);
            });
          },
          items: widget.genders.map<DropdownMenuItem<String>>((String gender) {
            return DropdownMenuItem<String>(
              value: gender,
              child: Text(gender),
            );
          }).toList(),
        ),
      ),
    );
  }
}
