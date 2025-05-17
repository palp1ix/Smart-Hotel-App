//
//  Generated code. Do not modify.
//  source: device_commands.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'device_commands.pb.dart' as $0;
import 'device_commands.pbjson.dart';

export 'device_commands.pb.dart';

abstract class DeviceControllerServiceBase extends $pb.GeneratedService {
  $async.Future<$0.ControllerResponse> identify($pb.ServerContext ctx, $0.IdentifyRequest request);
  $async.Future<$0.ControllerResponse> getDeviceInfo($pb.ServerContext ctx, $0.ClientMessage request);
  $async.Future<$0.ControllerResponse> getDeviceState($pb.ServerContext ctx, $0.GetState request);
  $async.Future<$0.ControllerResponse> setDeviceState($pb.ServerContext ctx, $0.SetState request);
  $async.Future<$0.ControllerResponse> processClientMessage($pb.ServerContext ctx, $0.ClientMessage request);

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'Identify': return $0.IdentifyRequest();
      case 'GetDeviceInfo': return $0.ClientMessage();
      case 'GetDeviceState': return $0.GetState();
      case 'SetDeviceState': return $0.SetState();
      case 'ProcessClientMessage': return $0.ClientMessage();
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx, $core.String methodName, $pb.GeneratedMessage request) {
    switch (methodName) {
      case 'Identify': return this.identify(ctx, request as $0.IdentifyRequest);
      case 'GetDeviceInfo': return this.getDeviceInfo(ctx, request as $0.ClientMessage);
      case 'GetDeviceState': return this.getDeviceState(ctx, request as $0.GetState);
      case 'SetDeviceState': return this.setDeviceState(ctx, request as $0.SetState);
      case 'ProcessClientMessage': return this.processClientMessage(ctx, request as $0.ClientMessage);
      default: throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => DeviceControllerServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>> get $messageJson => DeviceControllerServiceBase$messageJson;
}

