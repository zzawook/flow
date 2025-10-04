import 'package:flow_mobile/generated/common/v1/transaction.pb.dart';

class RecurringSpending {
  final int id;
  final String displayName;
  final String category;
  final String? brandDomain;
  final String? brandName;
  final double expectedAmount;
  final DateTime? nextTransactionDate;
  final DateTime? lastTransactionDate;
  final int intervalDays;
  final int occurrenceCount;
  final List<int> transactionIds;
  final int year;
  final int month;

  RecurringSpending({
    required this.id,
    required this.displayName,
    required this.category,
    this.brandDomain,
    this.brandName,
    required this.expectedAmount,
    this.nextTransactionDate,
    this.lastTransactionDate,
    required this.intervalDays,
    required this.occurrenceCount,
    required this.transactionIds,
    required this.year,
    required this.month,
  });

  /// Factory from proto
  factory RecurringSpending.fromProto(RecurringTransactionDetail proto) {
    return RecurringSpending(
      id: proto.id.toInt(),
      displayName: proto.displayName,
      category: proto.category,
      brandDomain: proto.hasBrandDomain() ? proto.brandDomain : null,
      brandName: proto.hasBrandName() ? proto.brandName : null,
      expectedAmount: proto.expectedAmount,
      nextTransactionDate: proto.hasNextTransactionDate()
          ? proto.nextTransactionDate.toDateTime()
          : null,
      lastTransactionDate: proto.hasLastTransactionDate()
          ? proto.lastTransactionDate.toDateTime()
          : null,
      intervalDays: proto.intervalDays.toInt(),
      occurrenceCount: proto.occurrenceCount.toInt(),
      transactionIds: proto.transactionIds.map((e) => e.toInt()).toList(),
      year: proto.year.toInt(),
      month: proto.month.toInt(),
    );
  }

  /// Get period label for UI
  String get periodLabel {
    if (intervalDays >= 25 && intervalDays <= 35) return "Monthly";
    if (intervalDays >= 55 && intervalDays <= 70) return "Bi-Monthly";
    if (intervalDays >= 80 && intervalDays <= 100) return "Quarterly";
    return "Every $intervalDays days";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RecurringSpending &&
        other.id == id &&
        other.displayName == displayName &&
        other.category == category &&
        other.expectedAmount == expectedAmount &&
        other.year == year &&
        other.month == month;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        displayName.hashCode ^
        category.hashCode ^
        expectedAmount.hashCode ^
        year.hashCode ^
        month.hashCode;
  }
}
