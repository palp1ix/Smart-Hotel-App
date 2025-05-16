//
//  Generated code. Do not modify.
//  source: device_commands.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Statuses extends $pb.ProtobufEnum {
  static const Statuses Ok = Statuses._(0, _omitEnumNames ? '' : 'Ok');
  static const Statuses Error = Statuses._(1, _omitEnumNames ? '' : 'Error');

  static const $core.List<Statuses> values = <Statuses> [
    Ok,
    Error,
  ];

  static final $core.Map<$core.int, Statuses> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Statuses? valueOf($core.int value) => _byValue[value];

  const Statuses._(super.v, super.n);
}

class LighStates extends $pb.ProtobufEnum {
  static const LighStates On = LighStates._(0, _omitEnumNames ? '' : 'On');
  static const LighStates Off = LighStates._(1, _omitEnumNames ? '' : 'Off');

  static const $core.List<LighStates> values = <LighStates> [
    On,
    Off,
  ];

  static final $core.Map<$core.int, LighStates> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LighStates? valueOf($core.int value) => _byValue[value];

  const LighStates._(super.v, super.n);
}

class DoorLockStates extends $pb.ProtobufEnum {
  static const DoorLockStates Open = DoorLockStates._(0, _omitEnumNames ? '' : 'Open');
  static const DoorLockStates Close = DoorLockStates._(1, _omitEnumNames ? '' : 'Close');

  static const $core.List<DoorLockStates> values = <DoorLockStates> [
    Open,
    Close,
  ];

  static final $core.Map<$core.int, DoorLockStates> _byValue = $pb.ProtobufEnum.initByValue(values);
  static DoorLockStates? valueOf($core.int value) => _byValue[value];

  const DoorLockStates._(super.v, super.n);
}

class ChannelStates extends $pb.ProtobufEnum {
  static const ChannelStates ChannelOn = ChannelStates._(0, _omitEnumNames ? '' : 'ChannelOn');
  static const ChannelStates ChannelOff = ChannelStates._(1, _omitEnumNames ? '' : 'ChannelOff');

  static const $core.List<ChannelStates> values = <ChannelStates> [
    ChannelOn,
    ChannelOff,
  ];

  static final $core.Map<$core.int, ChannelStates> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ChannelStates? valueOf($core.int value) => _byValue[value];

  const ChannelStates._(super.v, super.n);
}

class States extends $pb.ProtobufEnum {
  static const States LightOn = States._(0, _omitEnumNames ? '' : 'LightOn');
  static const States LightOff = States._(1, _omitEnumNames ? '' : 'LightOff');
  static const States DoorLockOpen = States._(2, _omitEnumNames ? '' : 'DoorLockOpen');
  static const States DoorLockClose = States._(3, _omitEnumNames ? '' : 'DoorLockClose');
  static const States Channel1On = States._(4, _omitEnumNames ? '' : 'Channel1On');
  static const States Channel1Off = States._(5, _omitEnumNames ? '' : 'Channel1Off');
  static const States Channel2On = States._(6, _omitEnumNames ? '' : 'Channel2On');
  static const States Channel2Off = States._(7, _omitEnumNames ? '' : 'Channel2Off');

  static const $core.List<States> values = <States> [
    LightOn,
    LightOff,
    DoorLockOpen,
    DoorLockClose,
    Channel1On,
    Channel1Off,
    Channel2On,
    Channel2Off,
  ];

  static final $core.Map<$core.int, States> _byValue = $pb.ProtobufEnum.initByValue(values);
  static States? valueOf($core.int value) => _byValue[value];

  const States._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
