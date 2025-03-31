class SpendingCategoryUtil {
  static Map<String, Map<String, dynamic>> categoryData = {
    "Transfer": {"color": "#8BC34A"},
    "Transport": {"color": "#FF9800"},
    "Food": {"color": "#F44336"},
    "Others": {"color": "#9E9E9E"},
    "Groceries": {"color": "#2196F3"},
    "Entertainment": {"color": "#673AB7"},
    "Shopping": {"color": "#FFC107"},
    "Bills": {"color": "#FF5722"},
    "Health": {"color": "#4CAF50"},
    "Travel": {"color": "#03A9F4"},
    "Education": {"color": "#9C27B0"},
    "Investment": {"color": "#00BCD4"},
    "Gift": {"color": "#E91E63"},
    "Salary": {"color": "#009688"},
    "Bonus": {"color": "#607D8B"},
    "Interest": {"color": "#795548"},
    "Dividend": {"color": "#FFEB3B"},
    "Refund": {"color": "#CDDC39"},
    "Cashback": {"color": "#FF9800"},
    "Rebate": {"color": "#FF5722"},
    "Award": {"color": "#4CAF50"},
    "Coupon": {"color": "#FFC107"},
    "Lottery": {"color": "#9C27B0"},
  };

  static getCategoryColor(String category) {
    if (!categoryData.containsKey(category)) {
      return "#000000";
    }
    return categoryData[category]!["color"];
  }

  static bool isCategoryExist(String category) {
    return categoryData.containsKey(category);
  }
}
