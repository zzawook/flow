class BalanceData {
  double income = 0;
  double card = 0;
  double transfer = 0;
  double other = 0;

  BalanceData(this.income, this.card, this.transfer, this.other);

  static BalanceData fromDynamicJson(dynamic json) {
    if (json is Map) {
      if (json.containsKey('income') &&
          json.containsKey('card') &&
          json.containsKey('transfer') &&
          json.containsKey('other')) {
        return BalanceData(
          json['income'],
          json['card'],
          json['transfer'],
          json['other'],
        );
      }
    }
    return BalanceData(0, 0, 0, 0);
  }

  dynamic toDynamicJson() {
    return {
      'income': income,
      'card': card,
      'transfer': transfer,
      'other': other,
    };
  }
}
