// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_spending_statistics.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

DateSpendingStatistics _$DateSpendingStatisticsFromJson(
    Map<String, dynamic> json) {
  return _DateSpendingStatistics.fromJson(json);
}

/// @nodoc
mixin _$DateSpendingStatistics {
  double get income => throw _privateConstructorUsedError;
  double get expense => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;

  /// Serializes this DateSpendingStatistics to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DateSpendingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DateSpendingStatisticsCopyWith<DateSpendingStatistics> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DateSpendingStatisticsCopyWith<$Res> {
  factory $DateSpendingStatisticsCopyWith(DateSpendingStatistics value,
          $Res Function(DateSpendingStatistics) then) =
      _$DateSpendingStatisticsCopyWithImpl<$Res, DateSpendingStatistics>;
  @useResult
  $Res call({double income, double expense, DateTime date});
}

/// @nodoc
class _$DateSpendingStatisticsCopyWithImpl<$Res,
        $Val extends DateSpendingStatistics>
    implements $DateSpendingStatisticsCopyWith<$Res> {
  _$DateSpendingStatisticsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DateSpendingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? date = null,
  }) {
    return _then(_value.copyWith(
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DateSpendingStatisticsImplCopyWith<$Res>
    implements $DateSpendingStatisticsCopyWith<$Res> {
  factory _$$DateSpendingStatisticsImplCopyWith(
          _$DateSpendingStatisticsImpl value,
          $Res Function(_$DateSpendingStatisticsImpl) then) =
      __$$DateSpendingStatisticsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double income, double expense, DateTime date});
}

/// @nodoc
class __$$DateSpendingStatisticsImplCopyWithImpl<$Res>
    extends _$DateSpendingStatisticsCopyWithImpl<$Res,
        _$DateSpendingStatisticsImpl>
    implements _$$DateSpendingStatisticsImplCopyWith<$Res> {
  __$$DateSpendingStatisticsImplCopyWithImpl(
      _$DateSpendingStatisticsImpl _value,
      $Res Function(_$DateSpendingStatisticsImpl) _then)
      : super(_value, _then);

  /// Create a copy of DateSpendingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? income = null,
    Object? expense = null,
    Object? date = null,
  }) {
    return _then(_$DateSpendingStatisticsImpl(
      income: null == income
          ? _value.income
          : income // ignore: cast_nullable_to_non_nullable
              as double,
      expense: null == expense
          ? _value.expense
          : expense // ignore: cast_nullable_to_non_nullable
              as double,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateSpendingStatisticsImpl implements _DateSpendingStatistics {
  const _$DateSpendingStatisticsImpl(
      {required this.income, required this.expense, required this.date});

  factory _$DateSpendingStatisticsImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateSpendingStatisticsImplFromJson(json);

  @override
  final double income;
  @override
  final double expense;
  @override
  final DateTime date;

  @override
  String toString() {
    return 'DateSpendingStatistics(income: $income, expense: $expense, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateSpendingStatisticsImpl &&
            (identical(other.income, income) || other.income == income) &&
            (identical(other.expense, expense) || other.expense == expense) &&
            (identical(other.date, date) || other.date == date));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, income, expense, date);

  /// Create a copy of DateSpendingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DateSpendingStatisticsImplCopyWith<_$DateSpendingStatisticsImpl>
      get copyWith => __$$DateSpendingStatisticsImplCopyWithImpl<
          _$DateSpendingStatisticsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$DateSpendingStatisticsImplToJson(
      this,
    );
  }
}

abstract class _DateSpendingStatistics implements DateSpendingStatistics {
  const factory _DateSpendingStatistics(
      {required final double income,
      required final double expense,
      required final DateTime date}) = _$DateSpendingStatisticsImpl;

  factory _DateSpendingStatistics.fromJson(Map<String, dynamic> json) =
      _$DateSpendingStatisticsImpl.fromJson;

  @override
  double get income;
  @override
  double get expense;
  @override
  DateTime get date;

  /// Create a copy of DateSpendingStatistics
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DateSpendingStatisticsImplCopyWith<_$DateSpendingStatisticsImpl>
      get copyWith => throw _privateConstructorUsedError;
}
