// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserStateModel {
  User get user => throw _privateConstructorUsedError;

  /// Create a copy of UserStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserStateModelCopyWith<UserStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStateModelCopyWith<$Res> {
  factory $UserStateModelCopyWith(
          UserStateModel value, $Res Function(UserStateModel) then) =
      _$UserStateModelCopyWithImpl<$Res, UserStateModel>;
  @useResult
  $Res call({User user});

  $UserCopyWith<$Res> get user;
}

/// @nodoc
class _$UserStateModelCopyWithImpl<$Res, $Val extends UserStateModel>
    implements $UserStateModelCopyWith<$Res> {
  _$UserStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_value.copyWith(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ) as $Val);
  }

  /// Create a copy of UserStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res> get user {
    return $UserCopyWith<$Res>(_value.user, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserStateModelImplCopyWith<$Res>
    implements $UserStateModelCopyWith<$Res> {
  factory _$$UserStateModelImplCopyWith(_$UserStateModelImpl value,
          $Res Function(_$UserStateModelImpl) then) =
      __$$UserStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({User user});

  @override
  $UserCopyWith<$Res> get user;
}

/// @nodoc
class __$$UserStateModelImplCopyWithImpl<$Res>
    extends _$UserStateModelCopyWithImpl<$Res, _$UserStateModelImpl>
    implements _$$UserStateModelImplCopyWith<$Res> {
  __$$UserStateModelImplCopyWithImpl(
      _$UserStateModelImpl _value, $Res Function(_$UserStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = null,
  }) {
    return _then(_$UserStateModelImpl(
      user: null == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User,
    ));
  }
}

/// @nodoc

class _$UserStateModelImpl implements _UserStateModel {
  const _$UserStateModelImpl({required this.user});

  @override
  final User user;

  @override
  String toString() {
    return 'UserStateModel(user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStateModelImpl &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, user);

  /// Create a copy of UserStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStateModelImplCopyWith<_$UserStateModelImpl> get copyWith =>
      __$$UserStateModelImplCopyWithImpl<_$UserStateModelImpl>(
          this, _$identity);
}

abstract class _UserStateModel implements UserStateModel {
  const factory _UserStateModel({required final User user}) =
      _$UserStateModelImpl;

  @override
  User get user;

  /// Create a copy of UserStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserStateModelImplCopyWith<_$UserStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
