class SpendingCategoryUtil {
  static Map<String, Map<String, dynamic>> categoryData = {
    "Transfer": {
      "color": "#8BC34A",
      "icon": "assets/icons/category_icons/transfer.png",
    },
    "Transport": {
      "color": "#FF9800",
      "icon": "assets/icons/category_icons/transport.png",
    },
    "Food": {
      "color": "#F44336",
      "icon": "assets/icons/category_icons/food.png",
    },
    "Others": {
      "color": "#9E9E9E",
      "icon": "assets/icons/category_icons/others.png",
    },
    "Groceries": {"color": "#2196F3"},
    "Entertainment": {
      "color": "#4a50f7",
      "icon": "assets/icons/category_icons/entertainment.png",
    },
    "Shopping": {"color": "#FFC107"},
    "Bills": {"color": "#FF5722"},
    "Medical": {"color": "#4CAF50"},
    "Beauty": {"color": "#03A9F4"},
    "Education": {"color": "#9C27B0"},
    "Insurance": {"color": "#00BCD4"},
    "Electronics": {"color": "#CDDC39"},
    "Communication": {"color": "#FF9800"},
    "Salary": {"color": "#FF98FF"},
  };

  static getCategoryColor(String category) {
    if (!categoryData.containsKey(category)) {
      return "#000000";
    }
    return categoryData[category]!["color"];
  }

  static getCategoryIcon(String category) {
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
