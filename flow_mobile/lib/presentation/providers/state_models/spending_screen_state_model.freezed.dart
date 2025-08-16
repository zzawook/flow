// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending_screen_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpendingScreenStateModel {
  bool get isLoading => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;
  DateTime get selectedDate => throw _privateConstructorUsedError;
  DateTime get calendarSelectedDate => throw _privateConstructorUsedError;
  DateTime get displayedMonth => throw _privateConstructorUsedError;
  DateTime get weeklySpendingCalendarDisplayWeek =>
      throw _privateConstructorUsedError;

  /// Create a copy of SpendingScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpendingScreenStateModelCopyWith<SpendingScreenStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendingScreenStateModelCopyWith<$Res> {
  factory $SpendingScreenStateModelCopyWith(SpendingScreenStateModel value,
          $Res Function(SpendingScreenStateModel) then) =
      _$SpendingScreenStateModelCopyWithImpl<$Res, SpendingScreenStateModel>;
  @useResult
  $Res call(
      {bool isLoading,
      String error,
      DateTime selectedDate,
      DateTime calendarSelectedDate,
      DateTime displayedMonth,
      DateTime weeklySpendingCalendarDisplayWeek});
}

/// @nodoc
class _$SpendingScreenStateModelCopyWithImpl<$Res,
        $Val extends SpendingScreenStateModel>
    implements $SpendingScreenStateModelCopyWith<$Res> {
  _$SpendingScreenStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpendingScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = null,
    Object? selectedDate = null,
    Object? calendarSelectedDate = null,
    Object? displayedMonth = null,
    Object? weeklySpendingCalendarDisplayWeek = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      calendarSelectedDate: null == calendarSelectedDate
          ? _value.calendarSelectedDate
          : calendarSelectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      displayedMonth: null == displayedMonth
          ? _value.displayedMonth
          : displayedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weeklySpendingCalendarDisplayWeek: null ==
              weeklySpendingCalendarDisplayWeek
          ? _value.weeklySpendingCalendarDisplayWeek
          : weeklySpendingCalendarDisplayWeek // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpendingScreenStateModelImplCopyWith<$Res>
    implements $SpendingScreenStateModelCopyWith<$Res> {
  factory _$$SpendingScreenStateModelImplCopyWith(
          _$SpendingScreenStateModelImpl value,
          $Res Function(_$SpendingScreenStateModelImpl) then) =
      __$$SpendingScreenStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      String error,
      DateTime selectedDate,
      DateTime calendarSelectedDate,
      DateTime displayedMonth,
      DateTime weeklySpendingCalendarDisplayWeek});
}

/// @nodoc
class __$$SpendingScreenStateModelImplCopyWithImpl<$Res>
    extends _$SpendingScreenStateModelCopyWithImpl<$Res,
        _$SpendingScreenStateModelImpl>
    implements _$$SpendingScreenStateModelImplCopyWith<$Res> {
  __$$SpendingScreenStateModelImplCopyWithImpl(
      _$SpendingScreenStateModelImpl _value,
      $Res Function(_$SpendingScreenStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpendingScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? error = null,
    Object? selectedDate = null,
    Object? calendarSelectedDate = null,
    Object? displayedMonth = null,
    Object? weeklySpendingCalendarDisplayWeek = null,
  }) {
    return _then(_$SpendingScreenStateModelImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
      selectedDate: null == selectedDate
          ? _value.selectedDate
          : selectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      calendarSelectedDate: null == calendarSelectedDate
          ? _value.calendarSelectedDate
          : calendarSelectedDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      displayedMonth: null == displayedMonth
          ? _value.displayedMonth
          : displayedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weeklySpendingCalendarDisplayWeek: null ==
              weeklySpendingCalendarDisplayWeek
          ? _value.weeklySpendingCalendarDisplayWeek
          : weeklySpendingCalendarDisplayWeek // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$SpendingScreenStateModelImpl implements _SpendingScreenStateModel {
  const _$SpendingScreenStateModelImpl(
      {this.isLoading = false,
      this.error = '',
      required this.selectedDate,
      required this.calendarSelectedDate,
      required this.displayedMonth,
      required this.weeklySpendingCalendarDisplayWeek});

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final String error;
  @override
  final DateTime selectedDate;
  @override
  final DateTime calendarSelectedDate;
  @override
  final DateTime displayedMonth;
  @override
  final DateTime weeklySpendingCalendarDisplayWeek;

  @override
  String toString() {
    return 'SpendingScreenStateModel(isLoading: $isLoading, error: $error, selectedDate: $selectedDate, calendarSelectedDate: $calendarSelectedDate, displayedMonth: $displayedMonth, weeklySpendingCalendarDisplayWeek: $weeklySpendingCalendarDisplayWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendingScreenStateModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.selectedDate, selectedDate) ||
                other.selectedDate == selectedDate) &&
            (identical(other.calendarSelectedDate, calendarSelectedDate) ||
                other.calendarSelectedDate == calendarSelectedDate) &&
            (identical(other.displayedMonth, displayedMonth) ||
                other.displayedMonth == displayedMonth) &&
            (identical(other.weeklySpendingCalendarDisplayWeek,
                    weeklySpendingCalendarDisplayWeek) ||
                other.weeklySpendingCalendarDisplayWeek ==
                    weeklySpendingCalendarDisplayWeek));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading, error, selectedDate,
      calendarSelectedDate, displayedMonth, weeklySpendingCalendarDisplayWeek);

  /// Create a copy of SpendingScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendingScreenStateModelImplCopyWith<_$SpendingScreenStateModelImpl>
      get copyWith => __$$SpendingScreenStateModelImplCopyWithImpl<
          _$SpendingScreenStateModelImpl>(this, _$identity);
}

abstract class _SpendingScreenStateModel implements SpendingScreenStateModel {
  const factory _SpendingScreenStateModel(
          {final bool isLoading,
          final String error,
          required final DateTime selectedDate,
          required final DateTime calendarSelectedDate,
          required final DateTime displayedMonth,
          required final DateTime weeklySpendingCalendarDisplayWeek}) =
      _$SpendingScreenStateModelImpl;

  @override
  bool get isLoading;
  @override
  String get error;
  @override
  DateTime get selectedDate;
  @override
  DateTime get calendarSelectedDate;
  @override
  DateTime get displayedMonth;
  @override
  DateTime get weeklySpendingCalendarDisplayWeek;

  /// Create a copy of SpendingScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpendingScreenStateModelImplCopyWith<_$SpendingScreenStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
