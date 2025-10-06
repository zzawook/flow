import 'package:flutter/material.dart';

class SpendingCategoryUtil {
  static Map<String, Map<String, dynamic>> categoryData = {
    "Transfer": {"color": "#6D4C41"}, // Brown 600
    "Transportation": {"color": "#F57C00"}, // Orange 700
    "Food": {"color": "#D32F2F"}, // Red 700
    "Others": {"color": "#616161"}, // Grey 700
    "Grocery": {"color": "#2E7D32"}, // Green 800
    "Entertainment": {"color": "#5E35B1"}, // Deep Purple 600
    "Travel": {"color": "#00796B"}, // Teal 700
    "Shopping": {"color": "#C2185B"}, // Pink 700
    "Utilities": {"color": "#E64A19"}, // Deep Orange 600
    "Health": {"color": "#00ACC1"}, // Cyan 600
    "Education": {"color": "#303F9F"}, // Indigo 700
    "Telecommunication": {"color": "#1976D2"}, // Blue 700
    "Finance": {"color": "#455A64"}, // Blue Grey 700
    "Salary": {"color": "#9E7C0C"}, // Dark Gold
    "Analyzing": {"color": "#757575"}, // Grey 600
    "Not Identifiable": {"color": "#9E9E9E"}, // Grey 500
  };

  static Color getCategoryColor(String category) {
    if (!categoryData.containsKey(category)) {
      return shadeWithHsl(Color(0xFF000000), 0.2);
    }
    String colorString = categoryData[category]!["color"];
    if (colorString.startsWith('#')) {
      colorString = colorString.substring(1);
    }
    return shadeWithHsl(Color(int.parse('FF$colorString', radix: 16)), 0.07);
  }

  static Color shadeWithHsl(Color base, double amount) {
    // amount positive → lighter, negative → darker
    final hsl = HSLColor.fromColor(base);
    final light = (hsl.lightness + amount).clamp(0.0, 1.0);
    return hsl.withLightness(light).toColor();
  }

  static dynamic getCategoryIcon(String category) {
    if (!categoryData.containsKey(category)) {
      return "assets/icons/category_icons/others.png";
    }
    return categoryData[category]!["icon"] ??
        "assets/icons/category_icons/others.png";
  }

  static bool isCategoryExist(String category) {
    return categoryData.containsKey(category);
  }

  static List<String> getAllCategories() {
    return categoryData.keys.toList();
  }
}
