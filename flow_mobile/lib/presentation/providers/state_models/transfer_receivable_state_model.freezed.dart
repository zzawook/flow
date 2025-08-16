// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_receivable_state_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TransferReceivableStateModel {
  List<TransferReceivable> get transferReceivables =>
      throw _privateConstructorUsedError;
  List<BankAccount> get myBankAccounts => throw _privateConstructorUsedError;

  /// Create a copy of TransferReceivableStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TransferReceivableStateModelCopyWith<TransferReceivableStateModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferReceivableStateModelCopyWith<$Res> {
  factory $TransferReceivableStateModelCopyWith(
          TransferReceivableStateModel value,
          $Res Function(TransferReceivableStateModel) then) =
      _$TransferReceivableStateModelCopyWithImpl<$Res,
          TransferReceivableStateModel>;
  @useResult
  $Res call(
      {List<TransferReceivable> transferReceivables,
      List<BankAccount> myBankAccounts});
}

/// @nodoc
class _$TransferReceivableStateModelCopyWithImpl<$Res,
        $Val extends TransferReceivableStateModel>
    implements $TransferReceivableStateModelCopyWith<$Res> {
  _$TransferReceivableStateModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TransferReceivableStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferReceivables = null,
    Object? myBankAccounts = null,
  }) {
    return _then(_value.copyWith(
      transferReceivables: null == transferReceivables
          ? _value.transferReceivables
          : transferReceivables // ignore: cast_nullable_to_non_nullable
              as List<TransferReceivable>,
      myBankAccounts: null == myBankAccounts
          ? _value.myBankAccounts
          : myBankAccounts // ignore: cast_nullable_to_non_nullable
              as List<BankAccount>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferReceivableStateModelImplCopyWith<$Res>
    implements $TransferReceivableStateModelCopyWith<$Res> {
  factory _$$TransferReceivableStateModelImplCopyWith(
          _$TransferReceivableStateModelImpl value,
          $Res Function(_$TransferReceivableStateModelImpl) then) =
      __$$TransferReceivableStateModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TransferReceivable> transferReceivables,
      List<BankAccount> myBankAccounts});
}

/// @nodoc
class __$$TransferReceivableStateModelImplCopyWithImpl<$Res>
    extends _$TransferReceivableStateModelCopyWithImpl<$Res,
        _$TransferReceivableStateModelImpl>
    implements _$$TransferReceivableStateModelImplCopyWith<$Res> {
  __$$TransferReceivableStateModelImplCopyWithImpl(
      _$TransferReceivableStateModelImpl _value,
      $Res Function(_$TransferReceivableStateModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of TransferReceivableStateModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transferReceivables = null,
    Object? myBankAccounts = null,
  }) {
    return _then(_$TransferReceivableStateModelImpl(
      transferReceivables: null == transferReceivables
          ? _value._transferReceivables
          : transferReceivables // ignore: cast_nullable_to_non_nullable
              as List<TransferReceivable>,
      myBankAccounts: null == myBankAccounts
          ? _value._myBankAccounts
          : myBankAccounts // ignore: cast_nullable_to_non_nullable
              as List<BankAccount>,
    ));
  }
}

/// @nodoc

class _$TransferReceivableStateModelImpl
    implements _TransferReceivableStateModel {
  const _$TransferReceivableStateModelImpl(
      {final List<TransferReceivable> transferReceivables = const [],
      final List<BankAccount> myBankAccounts = const []})
      : _transferReceivables = transferReceivables,
        _myBankAccounts = myBankAccounts;

  final List<TransferReceivable> _transferReceivables;
  @override
  @JsonKey()
  List<TransferReceivable> get transferReceivables {
    if (_transferReceivables is EqualUnmodifiableListView)
      return _transferReceivables;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_transferReceivables);
  }

  final List<BankAccount> _myBankAccounts;
  @override
  @JsonKey()
  List<BankAccount> get myBankAccounts {
    if (_myBankAccounts is EqualUnmodifiableListView) return _myBankAccounts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_myBankAccounts);
  }

  @override
  String toString() {
    return 'TransferReceivableStateModel(transferReceivables: $transferReceivables, myBankAccounts: $myBankAccounts)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferReceivableStateModelImpl &&
            const DeepCollectionEquality()
                .equals(other._transferReceivables, _transferReceivables) &&
            const DeepCollectionEquality()
                .equals(other._myBankAccounts, _myBankAccounts));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_transferReceivables),
      const DeepCollectionEquality().hash(_myBankAccounts));

  /// Create a copy of TransferReceivableStateModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferReceivableStateModelImplCopyWith<
          _$TransferReceivableStateModelImpl>
      get copyWith => __$$TransferReceivableStateModelImplCopyWithImpl<
          _$TransferReceivableStateModelImpl>(this, _$identity);
}

abstract class _TransferReceivableStateModel
    implements TransferReceivableStateModel {
  const factory _TransferReceivableStateModel(
          {final List<TransferReceivable> transferReceivables,
          final List<BankAccount> myBankAccounts}) =
      _$TransferReceivableStateModelImpl;

  @override
  List<TransferReceivable> get transferReceivables;
  @override
  List<BankAccount> get myBankAccounts;

  /// Create a copy of TransferReceivableStateModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TransferReceivableStateModelImplCopyWith<
          _$TransferReceivableStateModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
