import 'package:firebasework/config/theme/app_Color.dart';
import 'package:flutter/material.dart';

class BeautifulPopupMenuButton extends StatelessWidget {
  final Function()? onEdit;
  final Future<void> Function()? onDelete;

  const BeautifulPopupMenuButton({
    Key? key,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.9, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Color(0xFF333333), size: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(color: Colors.green.shade100, width: 1.5,),
            ),
            elevation: 12,
            color: Colors.white,
            offset: const Offset(0, 38),
            itemBuilder: (context) => [
              CustomPopupMenuItem(
                value: 'edit',
                icon: Icons.edit,
                text: 'Edit',
                textColor: AppColors.primary,
                iconColor: AppColors.primary,
              ),
              CustomPopupMenuItem(
                value: 'delete',
                icon: Icons.delete_outline,
                text: 'Delete',
                textColor: Colors.redAccent,
                iconColor: Colors.redAccent,
              ),
            ],
            onSelected: (value) async {
              if (value == 'edit') {
                if (onEdit != null) onEdit!();
              } else if (value == 'delete') {
                if (onDelete != null) {
                  await onDelete!();
                }
              }
            },
          ),
        );
      },
    );
  }
}

class CustomPopupMenuItem extends PopupMenuEntry<String> {
  final String value;
  final IconData icon;
  final String text;
  final Color textColor;
  final Color iconColor;

  const CustomPopupMenuItem({
    required this.value,
    required this.icon,
    required this.text,
    required this.textColor,
    required this.iconColor,
  });

  @override
  double get height => 48;

  @override
  bool represents(String? value) => value == this.value;

  @override
  State<CustomPopupMenuItem> createState() => _CustomPopupMenuItemState();
}

class _CustomPopupMenuItemState extends State<CustomPopupMenuItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context, widget.value),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        child: Row(
          children: [
            Icon(widget.icon, color: widget.iconColor, size: 22),
            const SizedBox(width: 14),
            Text(
              widget.text,
              style: TextStyle(fontSize: 16, color: widget.textColor, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}