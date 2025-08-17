// This is a generated file - do not edit.
//
// Generated from account/v1/account.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class AccountType extends $pb.ProtobufEnum {
  static const AccountType ACCOUNT_TYPE_UNSPECIFIED =
      AccountType._(0, _omitEnumNames ? '' : 'ACCOUNT_TYPE_UNSPECIFIED');
  static const AccountType SAVINGS =
      AccountType._(1, _omitEnumNames ? '' : 'SAVINGS');
  static const AccountType CURRENT =
      AccountType._(2, _omitEnumNames ? '' : 'CURRENT');
  static const AccountType FIXED_DEPOSIT =
      AccountType._(3, _omitEnumNames ? '' : 'FIXED_DEPOSIT');
  static const AccountType FOREIGN_CURRENCY =
      AccountType._(4, _omitEnumNames ? '' : 'FOREIGN_CURRENCY');
  static const AccountType OTHERS =
      AccountType._(5, _omitEnumNames ? '' : 'OTHERS');

  static const $core.List<AccountType> values = <AccountType>[
    ACCOUNT_TYPE_UNSPECIFIED,
    SAVINGS,
    CURRENT,
    FIXED_DEPOSIT,
    FOREIGN_CURRENCY,
    OTHERS,
  ];

  static final $core.List<AccountType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 5);
  static AccountType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const AccountType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
