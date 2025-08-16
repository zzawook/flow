// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'spending_category_screen_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SpendingCategoryScreenStateModel {
  DateTime get displayedMonth => throw _privateConstructorUsedError;

  /// Create a copy of SpendingCategoryScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpendingCategoryScreenStateModelCopyWith<SpendingCategoryScreenStateModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpendingCategoryScreenStateModelCopyWith<$Res> {
  factory $SpendingCategoryScreenStateModelCopyWith(
          SpendingCategoryScreenStateModel value,
          $Res Function(SpendingCategoryScreenStateModel) then) =
      _$SpendingCategoryScreenStateModelCopyWithImpl<$Res,
          SpendingCategoryScreenStateModel>;
  @useResult
  $Res call({DateTime displayedMonth});
}

/// @nodoc
class _$SpendingCategoryScreenStateModelCopyWithImpl<$Res,
        $Val extends SpendingCategoryScreenStateModel>
    implements $SpendingCategoryScreenStateModelCopyWith<$Res> {
  _$SpendingCategoryScreenStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpendingCategoryScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayedMonth = null,
  }) {
    return _then(_value.copyWith(
      displayedMonth: null == displayedMonth
          ? _value.displayedMonth
          : displayedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SpendingCategoryScreenStateModelImplCopyWith<$Res>
    implements $SpendingCategoryScreenStateModelCopyWith<$Res> {
  factory _$$SpendingCategoryScreenStateModelImplCopyWith(
          _$SpendingCategoryScreenStateModelImpl value,
          $Res Function(_$SpendingCategoryScreenStateModelImpl) then) =
      __$$SpendingCategoryScreenStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime displayedMonth});
}

/// @nodoc
class __$$SpendingCategoryScreenStateModelImplCopyWithImpl<$Res>
    extends _$SpendingCategoryScreenStateModelCopyWithImpl<$Res,
        _$SpendingCategoryScreenStateModelImpl>
    implements _$$SpendingCategoryScreenStateModelImplCopyWith<$Res> {
  __$$SpendingCategoryScreenStateModelImplCopyWithImpl(
      _$SpendingCategoryScreenStateModelImpl _value,
      $Res Function(_$SpendingCategoryScreenStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpendingCategoryScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? displayedMonth = null,
  }) {
    return _then(_$SpendingCategoryScreenStateModelImpl(
      displayedMonth: null == displayedMonth
          ? _value.displayedMonth
          : displayedMonth // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _$SpendingCategoryScreenStateModelImpl
    implements _SpendingCategoryScreenStateModel {
  const _$SpendingCategoryScreenStateModelImpl({required this.displayedMonth});

  @override
  final DateTime displayedMonth;

  @override
  String toString() {
    return 'SpendingCategoryScreenStateModel(displayedMonth: $displayedMonth)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpendingCategoryScreenStateModelImpl &&
            (identical(other.displayedMonth, displayedMonth) ||
                other.displayedMonth == displayedMonth));
  }

  @override
  int get hashCode => Object.hash(runtimeType, displayedMonth);

  /// Create a copy of SpendingCategoryScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpendingCategoryScreenStateModelImplCopyWith<
          _$SpendingCategoryScreenStateModelImpl>
      get copyWith => __$$SpendingCategoryScreenStateModelImplCopyWithImpl<
          _$SpendingCategoryScreenStateModelImpl>(this, _$identity);
}

abstract class _SpendingCategoryScreenStateModel
    implements SpendingCategoryScreenStateModel {
  const factory _SpendingCategoryScreenStateModel(
          {required final DateTime displayedMonth}) =
      _$SpendingCategoryScreenStateModelImpl;

  @override
  DateTime get displayedMonth;

  /// Create a copy of SpendingCategoryScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpendingCategoryScreenStateModelImplCopyWith<
          _$SpendingCategoryScreenStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
