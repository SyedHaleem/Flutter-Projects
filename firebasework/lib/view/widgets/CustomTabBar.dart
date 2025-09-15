import 'package:flutter/material.dart';
import 'package:firebasework/config/theme/app_Color.dart';

class CustomTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final Color? labelColor;
  final Color? indicatorColor;

  const CustomTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.labelColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 5),
      dividerColor: Colors.transparent,
      labelColor: labelColor ?? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
      indicatorColor: indicatorColor ?? AppColors.primary,
      tabs: tabs.map((tab) => Text(
        tab,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      )).toList(),
    );
  }
}