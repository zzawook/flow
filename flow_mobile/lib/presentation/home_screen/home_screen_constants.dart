import 'package:flutter/material.dart';

/// Shared colors & text styles for HomeScreen.
class HomeScreenColors {
  static const background    = Color(0xFFF5F5F5);
  static const primary       = Color(0xFF50C878);
  static const snackbarText  = Color(0xFFFFFFFF);
}

class HomeScreenTextStyles {
  static const snackBar = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: HomeScreenColors.snackbarText,
  );
}

/// Named route constants used on HomeScreen.
class HomeScreenRoutes {
  static const refresh = '/refresh';
}