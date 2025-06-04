import 'package:flutter/material.dart';

enum FixedSpendingCategory {
  telco,
  subscription,
  utilities,
  insurance,
  others,
  rent,
  installment,
}

extension FixedSpendingCategoryInfo on FixedSpendingCategory {
  String get label {
    switch (this) {
      case FixedSpendingCategory.telco:
        return 'Telco';
      case FixedSpendingCategory.subscription:
        return 'Subscription';
      case FixedSpendingCategory.utilities:
        return 'Utilities Bill';
      case FixedSpendingCategory.insurance:
        return 'Insurance';
      case FixedSpendingCategory.rent:
        return 'Rent';
      case FixedSpendingCategory.others:
        return 'Others';
      case FixedSpendingCategory.installment:
        return 'Installment';
    }
  }

  Icon get icon {
    switch (this) {
      case FixedSpendingCategory.telco:
        return Icon(Icons.phone_android, color: Colors.blue.shade400);
      case FixedSpendingCategory.subscription:
        return Icon(Icons.subscriptions, color: Colors.red.shade400);
      case FixedSpendingCategory.utilities:
        return Icon(Icons.lightbulb, color: Colors.yellow.shade600);
      case FixedSpendingCategory.insurance:
        return Icon(Icons.health_and_safety, color: Colors.green.shade300);
      case FixedSpendingCategory.rent:
        return Icon(Icons.home, color: Colors.brown.shade400);
      case FixedSpendingCategory.others:
        return Icon(Icons.more_horiz, color: Colors.grey);
      case FixedSpendingCategory.installment:
        return Icon(Icons.credit_card, color: Colors.purple.shade400);
    }
  }
}
