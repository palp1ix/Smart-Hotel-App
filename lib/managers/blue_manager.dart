import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smart_hotel_app/core/protobuf/device_commands.pb.dart';

class BlueManager {
  BlueManager({
    required this.deviceName,
    required this.serviceUuid,
    required this.characteristicTokenUuid,
    required this.characteristicUuid,
  });

  final String deviceName;
  final String serviceUuid;
  final String characteristicTokenUuid;
  final String characteristicUuid;

  Future<void> _turnOnBlue() async {
    if (!kIsWeb && Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }
  }

  Future<Stream<BluetoothAdapterState>> _getBlueAdapterStream() async {
    if (!await FlutterBluePlus.isSupported) {
      throw Exception('Bluetooth not supported by this device');
    }

    var subscription = FlutterBluePlus.adapterState;
    await _turnOnBlue();
    return subscription;
  }

  Future<BluetoothDevice?> findDeviceFromName(String deviceName) async {
    try {
      final adapterStream = await _getBlueAdapterStream();
      if (await adapterStream.first == BluetoothAdapterState.on) {
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
        final completer = Completer<BluetoothDevice>();
        final subscription = FlutterBluePlus.onScanResults.listen((results) {
          for (final result in results) {
            if (result.device.advName == deviceName) {
              FlutterBluePlus.stopScan();
              completer.complete(result.device);
              break;
            }
          }
        });
        return completer.future.timeout(
          const Duration(seconds: 20),
          onTimeout: () async {
            await FlutterBluePlus.stopScan();
            await subscription.cancel();
            throw Exception('No device with name $deviceName found!');
          },
        );
      } else {
        throw Exception('Bluetooth is off!');
      }
    } catch (e) {
      log('Error during scan: $e');
      return null;
    }
  }

  /// Discover and return the desired service by UUID
  Future<BluetoothService?> findServiceFromDevice(
    BluetoothDevice device,
  ) async {
    await device.connect();

    // Discover services with timeout
    List<BluetoothService> services;
    try {
      services = await device.discoverServices();
    } catch (e) {
      log('Error discovering services: $e');
      await device.disconnect();
      return null;
    }

    // Find the matching service
    final service = services.firstWhere(
      (s) => s.uuid == Guid(serviceUuid),
      orElse: () {
        log('Service $serviceUuid not found');
        throw Exception("Error");
      },
    );

    // Clean up: stop scan and/or disconnect if desired
    await FlutterBluePlus.stopScan();
    // Optionally disconnect here or keep connection for next operations
    // await device.disconnect();

    return service;
  }

  /// Find characteristic within a service by UUID
  BluetoothCharacteristic? findCharacteristicFromService(
    BluetoothService service,
    String characteristicName,
  ) {
    return service.characteristics.firstWhere(
      (c) => c.uuid == Guid(characteristicName),
      orElse: () {
        log('Characteristic $characteristicName not found');
        throw Exception("Error");
      },
    );
  }

  Uint8List prepareAndSendIdentifyRequest(String tokenValue) {
    // 1. Создать объект IdentifyRequest
    IdentifyRequest request = IdentifyRequest();

    // 2. Заполнить его данными
    request.token = tokenValue;

    // 3. Сериализовать в байты
    Uint8List dataToSend = request.writeToBuffer();

    log("Подготовленные байты для IdentifyRequest: $dataToSend");
    log("Размер: ${dataToSend.lengthInBytes} байт");
    return dataToSend;
  }

  // Функция для подготовки байтов для включения света
  Uint8List prepareTurnLightOnCommand() {
    // Шаг 1: Создаем сообщение SetState
    SetState setStatePayload = SetState();

    // Шаг 2: Устанавливаем желаемое состояние в SetState.
    // States.LightOn приходит из твоего сгенерированного device_commands.pbenum.dart
    setStatePayload.state = States.LightOff;

    // Шаг 3: Создаем "контейнер" ClientMessage
    ClientMessage clientMessage = ClientMessage();

    // Шаг 4: Помещаем наш SetState внутрь ClientMessage.
    // Присваивание полю `setState` автоматически выбирает его как активное поле в `oneof message`.
    clientMessage.setState = setStatePayload;

    // Шаг 5: Сериализуем ClientMessage в байтовый массив
    Uint8List bytesToSend = clientMessage.writeToBuffer();

    // Выводим для проверки (опционально)
    log(
      'Сериализованные байты для включения света (ClientMessage): $bytesToSend',
    );
    log('Размер данных: ${bytesToSend.lengthInBytes} байт');

    return bytesToSend;
  }

  /// Готовит сериализованные байты для ClientMessage с командой SetState.
  ///
  /// [stateToSet]: Значение из enum States, которое необходимо установить.
  Uint8List prepareSetStateCommand(States stateToSet) {
    ClientMessage clientMessage = ClientMessage();
    clientMessage.setState = SetState(state: stateToSet);

    Uint8List bytesToSend = clientMessage.writeToBuffer();

    log(
      'Подготовлен ClientMessage (SetState: ${stateToSet.name}): Байты=${bytesToSend.toString()}',
    );

    return bytesToSend;
  }

  Future<void> justTestFunc() async {
    final device = await findDeviceFromName(deviceName);
    if (device == null) {
      log('Device $deviceName not found');
      return;
    }

    final service = await findServiceFromDevice(device);
    if (service == null) {
      log('Service $serviceUuid not found on device');
      return;
    }

    final tokenCharacteristic = findCharacteristicFromService(
      service,
      characteristicTokenUuid,
    );
    if (tokenCharacteristic == null) {
      log('Characteristic $characteristicTokenUuid not found');
      return;
    }
    final bytes = prepareAndSendIdentifyRequest("CE0HOsYGo2oS8sdF");
    await tokenCharacteristic.write(bytes);
    log('Writen');

    final characteristic = findCharacteristicFromService(
      service,
      characteristicUuid,
    );

    // Предположим, вы уже получили объект `BluetoothCharacteristic characteristic`
    await characteristic?.setNotifyValue(true); // включает уведомления
    final subscription = characteristic?.onValueReceived.listen((
      List<int> value,
    ) {
      // сюда придут байты ответа от контроллера
      log('Notification received: $value');
    });
    subscription != null ? device.cancelWhenDisconnected(subscription) : null;

    final bytesLight = prepareSetStateCommand(States.DoorLockOpen);
    await characteristic?.write(bytesLight);
  }

  Stream<List<ScanResult>> get scanResultStream =>
      FlutterBluePlus.onScanResults;
}
