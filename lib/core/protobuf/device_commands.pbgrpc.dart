//
//  Generated code. Do not modify.
//  source: device_commands.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'package:protobuf/protobuf.dart' as $pb;

import 'device_commands.pb.dart' as $0;

export 'device_commands.pb.dart';

@$pb.GrpcServiceName('DeviceController')
class DeviceControllerClient extends $grpc.Client {
  static final _$identify = $grpc.ClientMethod<$0.IdentifyRequest, $0.ControllerResponse>(
      '/DeviceController/Identify',
      ($0.IdentifyRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ControllerResponse.fromBuffer(value));
  static final _$getDeviceInfo = $grpc.ClientMethod<$0.ClientMessage, $0.ControllerResponse>(
      '/DeviceController/GetDeviceInfo',
      ($0.ClientMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ControllerResponse.fromBuffer(value));
  static final _$getDeviceState = $grpc.ClientMethod<$0.GetState, $0.ControllerResponse>(
      '/DeviceController/GetDeviceState',
      ($0.GetState value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ControllerResponse.fromBuffer(value));
  static final _$setDeviceState = $grpc.ClientMethod<$0.SetState, $0.ControllerResponse>(
      '/DeviceController/SetDeviceState',
      ($0.SetState value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ControllerResponse.fromBuffer(value));
  static final _$processClientMessage = $grpc.ClientMethod<$0.ClientMessage, $0.ControllerResponse>(
      '/DeviceController/ProcessClientMessage',
      ($0.ClientMessage value) => value.writeToBuffer(),
      ($core.List<$core.int> value) => $0.ControllerResponse.fromBuffer(value));

  DeviceControllerClient(super.channel, {super.options, super.interceptors});

  $grpc.ResponseFuture<$0.ControllerResponse> identify($0.IdentifyRequest request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$identify, request, options: options);
  }

  $grpc.ResponseFuture<$0.ControllerResponse> getDeviceInfo($0.ClientMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDeviceInfo, request, options: options);
  }

  $grpc.ResponseFuture<$0.ControllerResponse> getDeviceState($0.GetState request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$getDeviceState, request, options: options);
  }

  $grpc.ResponseFuture<$0.ControllerResponse> setDeviceState($0.SetState request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$setDeviceState, request, options: options);
  }

  $grpc.ResponseFuture<$0.ControllerResponse> processClientMessage($0.ClientMessage request, {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$processClientMessage, request, options: options);
  }
}

@$pb.GrpcServiceName('DeviceController')
abstract class DeviceControllerServiceBase extends $grpc.Service {
  $core.String get $name => 'DeviceController';

  DeviceControllerServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.IdentifyRequest, $0.ControllerResponse>(
        'Identify',
        identify_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.IdentifyRequest.fromBuffer(value),
        ($0.ControllerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClientMessage, $0.ControllerResponse>(
        'GetDeviceInfo',
        getDeviceInfo_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ClientMessage.fromBuffer(value),
        ($0.ControllerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.GetState, $0.ControllerResponse>(
        'GetDeviceState',
        getDeviceState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.GetState.fromBuffer(value),
        ($0.ControllerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.SetState, $0.ControllerResponse>(
        'SetDeviceState',
        setDeviceState_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.SetState.fromBuffer(value),
        ($0.ControllerResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.ClientMessage, $0.ControllerResponse>(
        'ProcessClientMessage',
        processClientMessage_Pre,
        false,
        false,
        ($core.List<$core.int> value) => $0.ClientMessage.fromBuffer(value),
        ($0.ControllerResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.ControllerResponse> identify_Pre($grpc.ServiceCall $call, $async.Future<$0.IdentifyRequest> $request) async {
    return identify($call, await $request);
  }

  $async.Future<$0.ControllerResponse> getDeviceInfo_Pre($grpc.ServiceCall $call, $async.Future<$0.ClientMessage> $request) async {
    return getDeviceInfo($call, await $request);
  }

  $async.Future<$0.ControllerResponse> getDeviceState_Pre($grpc.ServiceCall $call, $async.Future<$0.GetState> $request) async {
    return getDeviceState($call, await $request);
  }

  $async.Future<$0.ControllerResponse> setDeviceState_Pre($grpc.ServiceCall $call, $async.Future<$0.SetState> $request) async {
    return setDeviceState($call, await $request);
  }

  $async.Future<$0.ControllerResponse> processClientMessage_Pre($grpc.ServiceCall $call, $async.Future<$0.ClientMessage> $request) async {
    return processClientMessage($call, await $request);
  }

  $async.Future<$0.ControllerResponse> identify($grpc.ServiceCall call, $0.IdentifyRequest request);
  $async.Future<$0.ControllerResponse> getDeviceInfo($grpc.ServiceCall call, $0.ClientMessage request);
  $async.Future<$0.ControllerResponse> getDeviceState($grpc.ServiceCall call, $0.GetState request);
  $async.Future<$0.ControllerResponse> setDeviceState($grpc.ServiceCall call, $0.SetState request);
  $async.Future<$0.ControllerResponse> processClientMessage($grpc.ServiceCall call, $0.ClientMessage request);
}
