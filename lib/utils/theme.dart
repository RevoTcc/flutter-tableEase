import 'package:flutter/material.dart';
import 'package:table_ease/utils/colors.dart';
import 'package:table_ease/utils/fonts.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        textTheme: AppFonts.text,
        focusColor: AppColors.yellow,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.yellow,
          secondary: AppColors.yellow,
          tertiary: AppColors.gray,
          error: AppColors.error,
          outline: AppColors.gray,
        ),
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: AppBarTheme(
          titleTextStyle: AppFonts.text.headlineMedium,
          color: AppColors.yellow,
        ),
      );

  static ThemeData get darkTheme => ThemeData(
        textTheme: AppFonts.text,
        focusColor: AppColors.blue,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.blue,
          secondary: AppColors.blue,
          tertiary: AppColors.gray,
          error: AppColors.error,
          outline: AppColors.gray,
        ),
        scaffoldBackgroundColor: AppColors.black50,
        appBarTheme: AppBarTheme(
          titleTextStyle: AppFonts.text.headlineMedium,
          color: AppColors.black100,
        ),
      );
}
