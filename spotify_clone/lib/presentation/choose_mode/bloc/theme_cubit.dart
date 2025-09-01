import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light); // Default theme is light mode

  void updateTheme(ThemeMode themeMode) {
    emit(themeMode);
  }

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    return json['isDarkMode'] == true ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Map<String, dynamic> toJson(ThemeMode state) {
    return {'isDarkMode': state == ThemeMode.dark};
  }
}
