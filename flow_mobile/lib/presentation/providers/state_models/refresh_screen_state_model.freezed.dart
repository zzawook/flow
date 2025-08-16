// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'refresh_screen_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RefreshScreenStateModel {
  List<Bank> get banksToRefresh => throw _privateConstructorUsedError;

  /// Create a copy of RefreshScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RefreshScreenStateModelCopyWith<RefreshScreenStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RefreshScreenStateModelCopyWith<$Res> {
  factory $RefreshScreenStateModelCopyWith(RefreshScreenStateModel value,
          $Res Function(RefreshScreenStateModel) then) =
      _$RefreshScreenStateModelCopyWithImpl<$Res, RefreshScreenStateModel>;
  @useResult
  $Res call({List<Bank> banksToRefresh});
}

/// @nodoc
class _$RefreshScreenStateModelCopyWithImpl<$Res,
        $Val extends RefreshScreenStateModel>
    implements $RefreshScreenStateModelCopyWith<$Res> {
  _$RefreshScreenStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RefreshScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? banksToRefresh = null,
  }) {
    return _then(_value.copyWith(
      banksToRefresh: null == banksToRefresh
          ? _value.banksToRefresh
          : banksToRefresh // ignore: cast_nullable_to_non_nullable
              as List<Bank>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RefreshScreenStateModelImplCopyWith<$Res>
    implements $RefreshScreenStateModelCopyWith<$Res> {
  factory _$$RefreshScreenStateModelImplCopyWith(
          _$RefreshScreenStateModelImpl value,
          $Res Function(_$RefreshScreenStateModelImpl) then) =
      __$$RefreshScreenStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Bank> banksToRefresh});
}

/// @nodoc
class __$$RefreshScreenStateModelImplCopyWithImpl<$Res>
    extends _$RefreshScreenStateModelCopyWithImpl<$Res,
        _$RefreshScreenStateModelImpl>
    implements _$$RefreshScreenStateModelImplCopyWith<$Res> {
  __$$RefreshScreenStateModelImplCopyWithImpl(
      _$RefreshScreenStateModelImpl _value,
      $Res Function(_$RefreshScreenStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of RefreshScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? banksToRefresh = null,
  }) {
    return _then(_$RefreshScreenStateModelImpl(
      banksToRefresh: null == banksToRefresh
          ? _value._banksToRefresh
          : banksToRefresh // ignore: cast_nullable_to_non_nullable
              as List<Bank>,
    ));
  }
}

/// @nodoc

class _$RefreshScreenStateModelImpl implements _RefreshScreenStateModel {
  const _$RefreshScreenStateModelImpl(
      {final List<Bank> banksToRefresh = const []})
      : _banksToRefresh = banksToRefresh;

  final List<Bank> _banksToRefresh;
  @override
  @JsonKey()
  List<Bank> get banksToRefresh {
    if (_banksToRefresh is EqualUnmodifiableListView) return _banksToRefresh;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_banksToRefresh);
  }

  @override
  String toString() {
    return 'RefreshScreenStateModel(banksToRefresh: $banksToRefresh)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RefreshScreenStateModelImpl &&
            const DeepCollectionEquality()
                .equals(other._banksToRefresh, _banksToRefresh));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_banksToRefresh));

  /// Create a copy of RefreshScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RefreshScreenStateModelImplCopyWith<_$RefreshScreenStateModelImpl>
      get copyWith => __$$RefreshScreenStateModelImplCopyWithImpl<
          _$RefreshScreenStateModelImpl>(this, _$identity);
}

abstract class _RefreshScreenStateModel implements RefreshScreenStateModel {
  const factory _RefreshScreenStateModel({final List<Bank> banksToRefresh}) =
      _$RefreshScreenStateModelImpl;

  @override
  List<Bank> get banksToRefresh;

  /// Create a copy of RefreshScreenStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RefreshScreenStateModelImplCopyWith<_$RefreshScreenStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
