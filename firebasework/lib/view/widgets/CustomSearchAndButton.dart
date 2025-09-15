import 'package:flutter/material.dart';
import 'package:firebasework/config/theme/app_Color.dart';

class CustomSearchAndButton extends StatelessWidget {
  final TextEditingController search;
  final Function(String)? onSearch;

  CustomSearchAndButton({super.key, this.onSearch})
      : search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Container(
          width: 337,
          height: 45,
          decoration: const BoxDecoration(
            color: Color(0xFFF9FAFB),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
          ),
          child: TextField(
            controller: search,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(left: 15, bottom: 5),
              border: InputBorder.none,
              hintText: "Search blogs, authors, or topics...",
              hintStyle: TextStyle(
                color: Color(0xFFAFAEAE),
                fontSize: 12,
              ),
            ),
            onSubmitted: (value) => onSearch?.call(value),
          ),
        ),
        SizedBox(
          width: 44,
          height: 45,
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
              ),
              backgroundColor: const MaterialStatePropertyAll(AppColors.primary),
            ),
            onPressed: () => onSearch?.call(search.text),
            child: const Icon(Icons.search_outlined, color: Colors.white),
          ),
        ),
      ],
    );
  }
}