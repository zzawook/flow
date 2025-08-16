// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NotificationStateModel {
  List<Notification> get notifications => throw _privateConstructorUsedError;

  /// Create a copy of NotificationStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationStateModelCopyWith<NotificationStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationStateModelCopyWith<$Res> {
  factory $NotificationStateModelCopyWith(NotificationStateModel value,
          $Res Function(NotificationStateModel) then) =
      _$NotificationStateModelCopyWithImpl<$Res, NotificationStateModel>;
  @useResult
  $Res call({List<Notification> notifications});
}

/// @nodoc
class _$NotificationStateModelCopyWithImpl<$Res,
        $Val extends NotificationStateModel>
    implements $NotificationStateModelCopyWith<$Res> {
  _$NotificationStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
  }) {
    return _then(_value.copyWith(
      notifications: null == notifications
          ? _value.notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<Notification>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationStateModelImplCopyWith<$Res>
    implements $NotificationStateModelCopyWith<$Res> {
  factory _$$NotificationStateModelImplCopyWith(
          _$NotificationStateModelImpl value,
          $Res Function(_$NotificationStateModelImpl) then) =
      __$$NotificationStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Notification> notifications});
}

/// @nodoc
class __$$NotificationStateModelImplCopyWithImpl<$Res>
    extends _$NotificationStateModelCopyWithImpl<$Res,
        _$NotificationStateModelImpl>
    implements _$$NotificationStateModelImplCopyWith<$Res> {
  __$$NotificationStateModelImplCopyWithImpl(
      _$NotificationStateModelImpl _value,
      $Res Function(_$NotificationStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notifications = null,
  }) {
    return _then(_$NotificationStateModelImpl(
      notifications: null == notifications
          ? _value._notifications
          : notifications // ignore: cast_nullable_to_non_nullable
              as List<Notification>,
    ));
  }
}

/// @nodoc

class _$NotificationStateModelImpl implements _NotificationStateModel {
  const _$NotificationStateModelImpl(
      {final List<Notification> notifications = const []})
      : _notifications = notifications;

  final List<Notification> _notifications;
  @override
  @JsonKey()
  List<Notification> get notifications {
    if (_notifications is EqualUnmodifiableListView) return _notifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notifications);
  }

  @override
  String toString() {
    return 'NotificationStateModel(notifications: $notifications)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationStateModelImpl &&
            const DeepCollectionEquality()
                .equals(other._notifications, _notifications));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_notifications));

  /// Create a copy of NotificationStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationStateModelImplCopyWith<_$NotificationStateModelImpl>
      get copyWith => __$$NotificationStateModelImplCopyWithImpl<
          _$NotificationStateModelImpl>(this, _$identity);
}

abstract class _NotificationStateModel implements NotificationStateModel {
  const factory _NotificationStateModel(
      {final List<Notification> notifications}) = _$NotificationStateModelImpl;

  @override
  List<Notification> get notifications;

  /// Create a copy of NotificationStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationStateModelImplCopyWith<_$NotificationStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
