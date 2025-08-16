// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppStateModel {
  UserStateModel get userState => throw _privateConstructorUsedError;
  TransferStateModel get transferState => throw _privateConstructorUsedError;
  SettingsStateModel get settingsState => throw _privateConstructorUsedError;
  ScreenStateModel get screenState => throw _privateConstructorUsedError;
  BankAccountStateModel get bankAccountState =>
      throw _privateConstructorUsedError;
  TransactionStateModel get transactionState =>
      throw _privateConstructorUsedError;
  TransferReceivableStateModel get transferReceivableState =>
      throw _privateConstructorUsedError;
  NotificationStateModel get notificationState =>
      throw _privateConstructorUsedError;

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppStateModelCopyWith<AppStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateModelCopyWith<$Res> {
  factory $AppStateModelCopyWith(
          AppStateModel value, $Res Function(AppStateModel) then) =
      _$AppStateModelCopyWithImpl<$Res, AppStateModel>;
  @useResult
  $Res call(
      {UserStateModel userState,
      TransferStateModel transferState,
      SettingsStateModel settingsState,
      ScreenStateModel screenState,
      BankAccountStateModel bankAccountState,
      TransactionStateModel transactionState,
      TransferReceivableStateModel transferReceivableState,
      NotificationStateModel notificationState});

  $UserStateModelCopyWith<$Res> get userState;
  $TransferStateModelCopyWith<$Res> get transferState;
  $SettingsStateModelCopyWith<$Res> get settingsState;
  $ScreenStateModelCopyWith<$Res> get screenState;
  $BankAccountStateModelCopyWith<$Res> get bankAccountState;
  $TransactionStateModelCopyWith<$Res> get transactionState;
  $TransferReceivableStateModelCopyWith<$Res> get transferReceivableState;
  $NotificationStateModelCopyWith<$Res> get notificationState;
}

/// @nodoc
class _$AppStateModelCopyWithImpl<$Res, $Val extends AppStateModel>
    implements $AppStateModelCopyWith<$Res> {
  _$AppStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userState = null,
    Object? transferState = null,
    Object? settingsState = null,
    Object? screenState = null,
    Object? bankAccountState = null,
    Object? transactionState = null,
    Object? transferReceivableState = null,
    Object? notificationState = null,
  }) {
    return _then(_value.copyWith(
      userState: null == userState
          ? _value.userState
          : userState // ignore: cast_nullable_to_non_nullable
              as UserStateModel,
      transferState: null == transferState
          ? _value.transferState
          : transferState // ignore: cast_nullable_to_non_nullable
              as TransferStateModel,
      settingsState: null == settingsState
          ? _value.settingsState
          : settingsState // ignore: cast_nullable_to_non_nullable
              as SettingsStateModel,
      screenState: null == screenState
          ? _value.screenState
          : screenState // ignore: cast_nullable_to_non_nullable
              as ScreenStateModel,
      bankAccountState: null == bankAccountState
          ? _value.bankAccountState
          : bankAccountState // ignore: cast_nullable_to_non_nullable
              as BankAccountStateModel,
      transactionState: null == transactionState
          ? _value.transactionState
          : transactionState // ignore: cast_nullable_to_non_nullable
              as TransactionStateModel,
      transferReceivableState: null == transferReceivableState
          ? _value.transferReceivableState
          : transferReceivableState // ignore: cast_nullable_to_non_nullable
              as TransferReceivableStateModel,
      notificationState: null == notificationState
          ? _value.notificationState
          : notificationState // ignore: cast_nullable_to_non_nullable
              as NotificationStateModel,
    ) as $Val);
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStateModelCopyWith<$Res> get userState {
    return $UserStateModelCopyWith<$Res>(_value.userState, (value) {
      return _then(_value.copyWith(userState: value) as $Val);
    });
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferStateModelCopyWith<$Res> get transferState {
    return $TransferStateModelCopyWith<$Res>(_value.transferState, (value) {
      return _then(_value.copyWith(transferState: value) as $Val);
    });
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SettingsStateModelCopyWith<$Res> get settingsState {
    return $SettingsStateModelCopyWith<$Res>(_value.settingsState, (value) {
      return _then(_value.copyWith(settingsState: value) as $Val);
    });
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ScreenStateModelCopyWith<$Res> get screenState {
    return $ScreenStateModelCopyWith<$Res>(_value.screenState, (value) {
      return _then(_value.copyWith(screenState: value) as $Val);
    });
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BankAccountStateModelCopyWith<$Res> get bankAccountState {
    return $BankAccountStateModelCopyWith<$Res>(_value.bankAccountState,
        (value) {
      return _then(_value.copyWith(bankAccountState: value) as $Val);
    });
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransactionStateModelCopyWith<$Res> get transactionState {
    return $TransactionStateModelCopyWith<$Res>(_value.transactionState,
        (value) {
      return _then(_value.copyWith(transactionState: value) as $Val);
    });
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $TransferReceivableStateModelCopyWith<$Res> get transferReceivableState {
    return $TransferReceivableStateModelCopyWith<$Res>(
        _value.transferReceivableState, (value) {
      return _then(_value.copyWith(transferReceivableState: value) as $Val);
    });
  }

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $NotificationStateModelCopyWith<$Res> get notificationState {
    return $NotificationStateModelCopyWith<$Res>(_value.notificationState,
        (value) {
      return _then(_value.copyWith(notificationState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppStateModelImplCopyWith<$Res>
    implements $AppStateModelCopyWith<$Res> {
  factory _$$AppStateModelImplCopyWith(
          _$AppStateModelImpl value, $Res Function(_$AppStateModelImpl) then) =
      __$$AppStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {UserStateModel userState,
      TransferStateModel transferState,
      SettingsStateModel settingsState,
      ScreenStateModel screenState,
      BankAccountStateModel bankAccountState,
      TransactionStateModel transactionState,
      TransferReceivableStateModel transferReceivableState,
      NotificationStateModel notificationState});

  @override
  $UserStateModelCopyWith<$Res> get userState;
  @override
  $TransferStateModelCopyWith<$Res> get transferState;
  @override
  $SettingsStateModelCopyWith<$Res> get settingsState;
  @override
  $ScreenStateModelCopyWith<$Res> get screenState;
  @override
  $BankAccountStateModelCopyWith<$Res> get bankAccountState;
  @override
  $TransactionStateModelCopyWith<$Res> get transactionState;
  @override
  $TransferReceivableStateModelCopyWith<$Res> get transferReceivableState;
  @override
  $NotificationStateModelCopyWith<$Res> get notificationState;
}

/// @nodoc
class __$$AppStateModelImplCopyWithImpl<$Res>
    extends _$AppStateModelCopyWithImpl<$Res, _$AppStateModelImpl>
    implements _$$AppStateModelImplCopyWith<$Res> {
  __$$AppStateModelImplCopyWithImpl(
      _$AppStateModelImpl _value, $Res Function(_$AppStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userState = null,
    Object? transferState = null,
    Object? settingsState = null,
    Object? screenState = null,
    Object? bankAccountState = null,
    Object? transactionState = null,
    Object? transferReceivableState = null,
    Object? notificationState = null,
  }) {
    return _then(_$AppStateModelImpl(
      userState: null == userState
          ? _value.userState
          : userState // ignore: cast_nullable_to_non_nullable
              as UserStateModel,
      transferState: null == transferState
          ? _value.transferState
          : transferState // ignore: cast_nullable_to_non_nullable
              as TransferStateModel,
      settingsState: null == settingsState
          ? _value.settingsState
          : settingsState // ignore: cast_nullable_to_non_nullable
              as SettingsStateModel,
      screenState: null == screenState
          ? _value.screenState
          : screenState // ignore: cast_nullable_to_non_nullable
              as ScreenStateModel,
      bankAccountState: null == bankAccountState
          ? _value.bankAccountState
          : bankAccountState // ignore: cast_nullable_to_non_nullable
              as BankAccountStateModel,
      transactionState: null == transactionState
          ? _value.transactionState
          : transactionState // ignore: cast_nullable_to_non_nullable
              as TransactionStateModel,
      transferReceivableState: null == transferReceivableState
          ? _value.transferReceivableState
          : transferReceivableState // ignore: cast_nullable_to_non_nullable
              as TransferReceivableStateModel,
      notificationState: null == notificationState
          ? _value.notificationState
          : notificationState // ignore: cast_nullable_to_non_nullable
              as NotificationStateModel,
    ));
  }
}

/// @nodoc

class _$AppStateModelImpl implements _AppStateModel {
  const _$AppStateModelImpl(
      {required this.userState,
      required this.transferState,
      required this.settingsState,
      required this.screenState,
      required this.bankAccountState,
      required this.transactionState,
      required this.transferReceivableState,
      required this.notificationState});

  @override
  final UserStateModel userState;
  @override
  final TransferStateModel transferState;
  @override
  final SettingsStateModel settingsState;
  @override
  final ScreenStateModel screenState;
  @override
  final BankAccountStateModel bankAccountState;
  @override
  final TransactionStateModel transactionState;
  @override
  final TransferReceivableStateModel transferReceivableState;
  @override
  final NotificationStateModel notificationState;

  @override
  String toString() {
    return 'AppStateModel(userState: $userState, transferState: $transferState, settingsState: $settingsState, screenState: $screenState, bankAccountState: $bankAccountState, transactionState: $transactionState, transferReceivableState: $transferReceivableState, notificationState: $notificationState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateModelImpl &&
            (identical(other.userState, userState) ||
                other.userState == userState) &&
            (identical(other.transferState, transferState) ||
                other.transferState == transferState) &&
            (identical(other.settingsState, settingsState) ||
                other.settingsState == settingsState) &&
            (identical(other.screenState, screenState) ||
                other.screenState == screenState) &&
            (identical(other.bankAccountState, bankAccountState) ||
                other.bankAccountState == bankAccountState) &&
            (identical(other.transactionState, transactionState) ||
                other.transactionState == transactionState) &&
            (identical(
                    other.transferReceivableState, transferReceivableState) ||
                other.transferReceivableState == transferReceivableState) &&
            (identical(other.notificationState, notificationState) ||
                other.notificationState == notificationState));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      userState,
      transferState,
      settingsState,
      screenState,
      bankAccountState,
      transactionState,
      transferReceivableState,
      notificationState);

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStateModelImplCopyWith<_$AppStateModelImpl> get copyWith =>
      __$$AppStateModelImplCopyWithImpl<_$AppStateModelImpl>(this, _$identity);
}

abstract class _AppStateModel implements AppStateModel {
  const factory _AppStateModel(
          {required final UserStateModel userState,
          required final TransferStateModel transferState,
          required final SettingsStateModel settingsState,
          required final ScreenStateModel screenState,
          required final BankAccountStateModel bankAccountState,
          required final TransactionStateModel transactionState,
          required final TransferReceivableStateModel transferReceivableState,
          required final NotificationStateModel notificationState}) =
      _$AppStateModelImpl;

  @override
  UserStateModel get userState;
  @override
  TransferStateModel get transferState;
  @override
  SettingsStateModel get settingsState;
  @override
  ScreenStateModel get screenState;
  @override
  BankAccountStateModel get bankAccountState;
  @override
  TransactionStateModel get transactionState;
  @override
  TransferReceivableStateModel get transferReceivableState;
  @override
  NotificationStateModel get notificationState;

  /// Create a copy of AppStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppStateModelImplCopyWith<_$AppStateModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
