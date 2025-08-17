// This is a generated file - do not edit.
//
// Generated from common/v1/bank.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Reusable Bank message
class Bank extends $pb.GeneratedMessage {
  factory Bank({
    $core.int? id,
    $core.String? name,
    $core.String? bankCode,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (bankCode != null) result.bankCode = bankCode;
    return result;
  }

  Bank._();

  factory Bank.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Bank.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Bank',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'sg.flow.common.v1'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.O3)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'bankCode')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bank clone() => Bank()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Bank copyWith(void Function(Bank) updates) =>
      super.copyWith((message) => updates(message as Bank)) as Bank;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Bank create() => Bank._();
  @$core.override
  Bank createEmptyInstance() => create();
  static $pb.PbList<Bank> createRepeated() => $pb.PbList<Bank>();
  @$core.pragma('dart2js:noInline')
  static Bank getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Bank>(create);
  static Bank? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get bankCode => $_getSZ(2);
  @$pb.TagNumber(3)
  set bankCode($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasBankCode() => $_has(2);
  @$pb.TagNumber(3)
  void clearBankCode() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
