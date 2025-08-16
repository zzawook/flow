// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bank_account_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$BankAccountStateModel {
  bool get isLoading => throw _privateConstructorUsedError;
  List<BankAccount> get bankAccounts => throw _privateConstructorUsedError;
  String get error => throw _privateConstructorUsedError;

  /// Create a copy of BankAccountStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BankAccountStateModelCopyWith<BankAccountStateModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BankAccountStateModelCopyWith<$Res> {
  factory $BankAccountStateModelCopyWith(BankAccountStateModel value,
          $Res Function(BankAccountStateModel) then) =
      _$BankAccountStateModelCopyWithImpl<$Res, BankAccountStateModel>;
  @useResult
  $Res call({bool isLoading, List<BankAccount> bankAccounts, String error});
}

/// @nodoc
class _$BankAccountStateModelCopyWithImpl<$Res,
        $Val extends BankAccountStateModel>
    implements $BankAccountStateModelCopyWith<$Res> {
  _$BankAccountStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BankAccountStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? bankAccounts = null,
    Object? error = null,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      bankAccounts: null == bankAccounts
          ? _value.bankAccounts
          : bankAccounts // ignore: cast_nullable_to_non_nullable
              as List<BankAccount>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BankAccountStateModelImplCopyWith<$Res>
    implements $BankAccountStateModelCopyWith<$Res> {
  factory _$$BankAccountStateModelImplCopyWith(
          _$BankAccountStateModelImpl value,
          $Res Function(_$BankAccountStateModelImpl) then) =
      __$$BankAccountStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isLoading, List<BankAccount> bankAccounts, String error});
}

/// @nodoc
class __$$BankAccountStateModelImplCopyWithImpl<$Res>
    extends _$BankAccountStateModelCopyWithImpl<$Res,
        _$BankAccountStateModelImpl>
    implements _$$BankAccountStateModelImplCopyWith<$Res> {
  __$$BankAccountStateModelImplCopyWithImpl(_$BankAccountStateModelImpl _value,
      $Res Function(_$BankAccountStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of BankAccountStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? bankAccounts = null,
    Object? error = null,
  }) {
    return _then(_$BankAccountStateModelImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      bankAccounts: null == bankAccounts
          ? _value._bankAccounts
          : bankAccounts // ignore: cast_nullable_to_non_nullable
              as List<BankAccount>,
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$BankAccountStateModelImpl implements _BankAccountStateModel {
  const _$BankAccountStateModelImpl(
      {this.isLoading = false,
      final List<BankAccount> bankAccounts = const [],
      this.error = ''})
      : _bankAccounts = bankAccounts;

  @override
  @JsonKey()
  final bool isLoading;
  final List<BankAccount> _bankAccounts;
  @override
  @JsonKey()
  List<BankAccount> get bankAccounts {
    if (_bankAccounts is EqualUnmodifiableListView) return _bankAccounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bankAccounts);
  }

  @override
  @JsonKey()
  final String error;

  @override
  String toString() {
    return 'BankAccountStateModel(isLoading: $isLoading, bankAccounts: $bankAccounts, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BankAccountStateModelImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality()
                .equals(other._bankAccounts, _bankAccounts) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_bankAccounts), error);

  /// Create a copy of BankAccountStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BankAccountStateModelImplCopyWith<_$BankAccountStateModelImpl>
      get copyWith => __$$BankAccountStateModelImplCopyWithImpl<
          _$BankAccountStateModelImpl>(this, _$identity);
}

abstract class _BankAccountStateModel implements BankAccountStateModel {
  const factory _BankAccountStateModel(
      {final bool isLoading,
      final List<BankAccount> bankAccounts,
      final String error}) = _$BankAccountStateModelImpl;

  @override
  bool get isLoading;
  @override
  List<BankAccount> get bankAccounts;
  @override
  String get error;

  /// Create a copy of BankAccountStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BankAccountStateModelImplCopyWith<_$BankAccountStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
