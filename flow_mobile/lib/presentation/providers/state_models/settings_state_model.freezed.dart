// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SettingsStateModel {
  SettingsV1 get settings => throw _privateConstructorUsedError;

  /// Create a copy of SettingsStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SettingsStateModelCopyWith<SettingsStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsStateModelCopyWith<$Res> {
  factory $SettingsStateModelCopyWith(
          SettingsStateModel value, $Res Function(SettingsStateModel) then) =
      _$SettingsStateModelCopyWithImpl<$Res, SettingsStateModel>;
  @useResult
  $Res call({SettingsV1 settings});
}

/// @nodoc
class _$SettingsStateModelCopyWithImpl<$Res, $Val extends SettingsStateModel>
    implements $SettingsStateModelCopyWith<$Res> {
  _$SettingsStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SettingsStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as SettingsV1,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsStateModelImplCopyWith<$Res>
    implements $SettingsStateModelCopyWith<$Res> {
  factory _$$SettingsStateModelImplCopyWith(_$SettingsStateModelImpl value,
          $Res Function(_$SettingsStateModelImpl) then) =
      __$$SettingsStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({SettingsV1 settings});
}

/// @nodoc
class __$$SettingsStateModelImplCopyWithImpl<$Res>
    extends _$SettingsStateModelCopyWithImpl<$Res, _$SettingsStateModelImpl>
    implements _$$SettingsStateModelImplCopyWith<$Res> {
  __$$SettingsStateModelImplCopyWithImpl(_$SettingsStateModelImpl _value,
      $Res Function(_$SettingsStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of SettingsStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? settings = null,
  }) {
    return _then(_$SettingsStateModelImpl(
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as SettingsV1,
    ));
  }
}

/// @nodoc

class _$SettingsStateModelImpl implements _SettingsStateModel {
  const _$SettingsStateModelImpl({required this.settings});

  @override
  final SettingsV1 settings;

  @override
  String toString() {
    return 'SettingsStateModel(settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SettingsStateModelImpl &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @override
  int get hashCode => Object.hash(runtimeType, settings);

  /// Create a copy of SettingsStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsStateModelImplCopyWith<_$SettingsStateModelImpl> get copyWith =>
      __$$SettingsStateModelImplCopyWithImpl<_$SettingsStateModelImpl>(
          this, _$identity);
}

abstract class _SettingsStateModel implements SettingsStateModel {
  const factory _SettingsStateModel({required final SettingsV1 settings}) =
      _$SettingsStateModelImpl;

  @override
  SettingsV1 get settings;

  /// Create a copy of SettingsStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SettingsStateModelImplCopyWith<_$SettingsStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
