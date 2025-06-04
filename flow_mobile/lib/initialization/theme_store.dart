import 'package:flow_mobile/domain/entity/setting_v1.dart';
import 'package:flutter/material.dart';

class ThemeStore {
  static ThemeData buildTheme(SettingsV1 settings) {
    if (settings.theme == "light") {
      return ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        primaryColor: Color(0xFF50C878),
        primaryColorLight: Color(0x8850C878),
        canvasColor: Color(0xFFF0F0F0),
        cardColor: Color(0xFFFFFFFF),
        dividerColor: Color(0xFFE0E0E0),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          titleMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
        disabledColor: Color(0xFFBDBDBD),
        scaffoldBackgroundColor: Color(0xFFF0F0F0),
        brightness: Brightness.light,
      );
    } else {
      return ThemeData(
        fontFamily: 'Inter',
        useMaterial3: true,
        primaryColor: Color(0xFF50C878),
        primaryColorLight: Color(0x8850C878),
        scaffoldBackgroundColor: Color(0xFF242424),

        dividerColor: Color(0xFFE0E0E0),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          headlineLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
          titleLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white.withAlpha(220),
          ),
          titleMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 22,
            fontWeight: FontWeight.normal,
            color: Colors.white.withAlpha(240),
          ),
          titleSmall: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.white.withAlpha(240),
          ),
          labelLarge: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          labelMedium: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: Colors.white,
          ),
        ),
        cardColor: Color(0xFF292929),
        canvasColor: Color(0xFF242424),
        disabledColor: Color(0xFF444444),
        brightness: Brightness.dark,
      );
    }
  }
}
