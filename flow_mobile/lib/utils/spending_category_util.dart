import 'package:flutter/material.dart';

class SpendingCategoryUtil {
  static Map<String, Map<String, dynamic>> categoryData = {
    "Transfer": {
      "color": "#9CCD4BC",
      "icon": "assets/icons/category_icons/transfer.png",
    },
    "Transportation": {
      "color": "#FF9800",
      "icon": "assets/icons/category_icons/transport.png",
    },
    "Food": {
      "color": "#F554477",
      "icon": "assets/icons/category_icons/food.png",
    },
    "Others": {
      "color": "#9E9E9E",
      "icon": "assets/icons/category_icons/others.png",
    },
    "Grocery": {"color": "#2196F3"},
    "Entertainment": {
      "color": "#4a50f7",
      "icon": "assets/icons/category_icons/entertainment.png",
    },
    "Travel": {"color": "#E91E63"},
    "Shopping": {"color": "#FFC107"},
    "Utilities": {"color": "#FF5722"},
    "Health": {"color": "#4CAF50"},
    "Beauty": {"color": "#03A9F4"},
    "Education": {"color": "#9C27B0"},
    "Insurance": {"color": "#00BCD4"},
    "Electronics": {"color": "#CDDC39"},
    "Telecommunication": {"color": "#FF9800"},
    "Finance": {"color": "#FF9800"},
    "Salary": {"color": "#FF98FF"},
    "Analyzing": {
      "color": "#9E9E9E",
      "icon": "assets/icons/category_icons/others.png",
    },
    "Not Identifiable": {
      "color": "#9E9E9E",
      "icon": "assets/icons/category_icons/others.png",
    },
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
