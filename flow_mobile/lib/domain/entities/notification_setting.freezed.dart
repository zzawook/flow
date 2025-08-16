// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NotificationSetting _$NotificationSettingFromJson(Map<String, dynamic> json) {
  return _NotificationSetting.fromJson(json);
}

/// @nodoc
mixin _$NotificationSetting {
  bool get masterEnabled => throw _privateConstructorUsedError;
  bool get insightNotificationEnabled => throw _privateConstructorUsedError;
  bool get periodicNotificationEnabled => throw _privateConstructorUsedError;
  bool get periodicNotificationAutoEnabled =>
      throw _privateConstructorUsedError;
  List<String> get periodicNotificationCron =>
      throw _privateConstructorUsedError;

  /// Serializes this NotificationSetting to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationSettingCopyWith<NotificationSetting> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationSettingCopyWith<$Res> {
  factory $NotificationSettingCopyWith(
          NotificationSetting value, $Res Function(NotificationSetting) then) =
      _$NotificationSettingCopyWithImpl<$Res, NotificationSetting>;
  @useResult
  $Res call(
      {bool masterEnabled,
      bool insightNotificationEnabled,
      bool periodicNotificationEnabled,
      bool periodicNotificationAutoEnabled,
      List<String> periodicNotificationCron});
}

/// @nodoc
class _$NotificationSettingCopyWithImpl<$Res, $Val extends NotificationSetting>
    implements $NotificationSettingCopyWith<$Res> {
  _$NotificationSettingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterEnabled = null,
    Object? insightNotificationEnabled = null,
    Object? periodicNotificationEnabled = null,
    Object? periodicNotificationAutoEnabled = null,
    Object? periodicNotificationCron = null,
  }) {
    return _then(_value.copyWith(
      masterEnabled: null == masterEnabled
          ? _value.masterEnabled
          : masterEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      insightNotificationEnabled: null == insightNotificationEnabled
          ? _value.insightNotificationEnabled
          : insightNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicNotificationEnabled: null == periodicNotificationEnabled
          ? _value.periodicNotificationEnabled
          : periodicNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicNotificationAutoEnabled: null == periodicNotificationAutoEnabled
          ? _value.periodicNotificationAutoEnabled
          : periodicNotificationAutoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicNotificationCron: null == periodicNotificationCron
          ? _value.periodicNotificationCron
          : periodicNotificationCron // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NotificationSettingImplCopyWith<$Res>
    implements $NotificationSettingCopyWith<$Res> {
  factory _$$NotificationSettingImplCopyWith(_$NotificationSettingImpl value,
          $Res Function(_$NotificationSettingImpl) then) =
      __$$NotificationSettingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool masterEnabled,
      bool insightNotificationEnabled,
      bool periodicNotificationEnabled,
      bool periodicNotificationAutoEnabled,
      List<String> periodicNotificationCron});
}

/// @nodoc
class __$$NotificationSettingImplCopyWithImpl<$Res>
    extends _$NotificationSettingCopyWithImpl<$Res, _$NotificationSettingImpl>
    implements _$$NotificationSettingImplCopyWith<$Res> {
  __$$NotificationSettingImplCopyWithImpl(_$NotificationSettingImpl _value,
      $Res Function(_$NotificationSettingImpl) _then)
      : super(_value, _then);

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? masterEnabled = null,
    Object? insightNotificationEnabled = null,
    Object? periodicNotificationEnabled = null,
    Object? periodicNotificationAutoEnabled = null,
    Object? periodicNotificationCron = null,
  }) {
    return _then(_$NotificationSettingImpl(
      masterEnabled: null == masterEnabled
          ? _value.masterEnabled
          : masterEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      insightNotificationEnabled: null == insightNotificationEnabled
          ? _value.insightNotificationEnabled
          : insightNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicNotificationEnabled: null == periodicNotificationEnabled
          ? _value.periodicNotificationEnabled
          : periodicNotificationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicNotificationAutoEnabled: null == periodicNotificationAutoEnabled
          ? _value.periodicNotificationAutoEnabled
          : periodicNotificationAutoEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      periodicNotificationCron: null == periodicNotificationCron
          ? _value._periodicNotificationCron
          : periodicNotificationCron // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationSettingImpl implements _NotificationSetting {
  const _$NotificationSettingImpl(
      {required this.masterEnabled,
      required this.insightNotificationEnabled,
      required this.periodicNotificationEnabled,
      required this.periodicNotificationAutoEnabled,
      required final List<String> periodicNotificationCron})
      : _periodicNotificationCron = periodicNotificationCron;

  factory _$NotificationSettingImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationSettingImplFromJson(json);

  @override
  final bool masterEnabled;
  @override
  final bool insightNotificationEnabled;
  @override
  final bool periodicNotificationEnabled;
  @override
  final bool periodicNotificationAutoEnabled;
  final List<String> _periodicNotificationCron;
  @override
  List<String> get periodicNotificationCron {
    if (_periodicNotificationCron is EqualUnmodifiableListView)
      return _periodicNotificationCron;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_periodicNotificationCron);
  }

  @override
  String toString() {
    return 'NotificationSetting(masterEnabled: $masterEnabled, insightNotificationEnabled: $insightNotificationEnabled, periodicNotificationEnabled: $periodicNotificationEnabled, periodicNotificationAutoEnabled: $periodicNotificationAutoEnabled, periodicNotificationCron: $periodicNotificationCron)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationSettingImpl &&
            (identical(other.masterEnabled, masterEnabled) ||
                other.masterEnabled == masterEnabled) &&
            (identical(other.insightNotificationEnabled,
                    insightNotificationEnabled) ||
                other.insightNotificationEnabled ==
                    insightNotificationEnabled) &&
            (identical(other.periodicNotificationEnabled,
                    periodicNotificationEnabled) ||
                other.periodicNotificationEnabled ==
                    periodicNotificationEnabled) &&
            (identical(other.periodicNotificationAutoEnabled,
                    periodicNotificationAutoEnabled) ||
                other.periodicNotificationAutoEnabled ==
                    periodicNotificationAutoEnabled) &&
            const DeepCollectionEquality().equals(
                other._periodicNotificationCron, _periodicNotificationCron));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      masterEnabled,
      insightNotificationEnabled,
      periodicNotificationEnabled,
      periodicNotificationAutoEnabled,
      const DeepCollectionEquality().hash(_periodicNotificationCron));

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationSettingImplCopyWith<_$NotificationSettingImpl> get copyWith =>
      __$$NotificationSettingImplCopyWithImpl<_$NotificationSettingImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationSettingImplToJson(
      this,
    );
  }
}

abstract class _NotificationSetting implements NotificationSetting {
  const factory _NotificationSetting(
          {required final bool masterEnabled,
          required final bool insightNotificationEnabled,
          required final bool periodicNotificationEnabled,
          required final bool periodicNotificationAutoEnabled,
          required final List<String> periodicNotificationCron}) =
      _$NotificationSettingImpl;

  factory _NotificationSetting.fromJson(Map<String, dynamic> json) =
      _$NotificationSettingImpl.fromJson;

  @override
  bool get masterEnabled;
  @override
  bool get insightNotificationEnabled;
  @override
  bool get periodicNotificationEnabled;
  @override
  bool get periodicNotificationAutoEnabled;
  @override
  List<String> get periodicNotificationCron;

  /// Create a copy of NotificationSetting
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationSettingImplCopyWith<_$NotificationSettingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
