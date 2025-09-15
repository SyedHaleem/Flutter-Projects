import 'package:firebasework/config/theme/app_Color.dart';
import 'package:flutter/material.dart';

class BasicAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool hideBackBtn;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final VoidCallback? onActionsTap;
  final bool isCircleAvatar;
  final String? avatarUrl;
  final VoidCallback? onAvatarTap;

  const BasicAppbar({
    super.key,
    this.title,
    this.hideBackBtn = false,
    this.onBack,
    this.actions,
    this.isCircleAvatar = false,
    this.avatarUrl,
    this.onAvatarTap, this.onActionsTap,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> actionWidgets = [];
    if (actions != null && actions!.isNotEmpty) {
      actionWidgets = actions!
          .map((action) => GestureDetector(
        onTap: onActionsTap,
        child: action,
      ))
          .toList();
    }

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: title ?? const Text(''),
      actions: actionWidgets,

      leading: hideBackBtn
          ? null
          : isCircleAvatar
          ? Padding(
        padding: const EdgeInsets.only(left: 10),
        child: GestureDetector(
          onTap: onAvatarTap,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary,
            backgroundImage: avatarUrl != null && avatarUrl!.isNotEmpty
                ? NetworkImage(avatarUrl!)
                : null,
            child: avatarUrl == null || avatarUrl!.isEmpty
                ? const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            )
                : null,
          ),
        ),
      )
          : IconButton(
        onPressed: () {
          onBack?.call();
          Navigator.of(context).maybePop();
        },
        icon: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.04),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            size: 15,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}