import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data'; // Добавлен импорт для Uint8List

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// Убедитесь, что путь к вашему protobuf файлу правильный
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
      // Проверим текущее состояние перед включением
      if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
        log('Bluetooth is off. Turning it on...');
        await FlutterBluePlus.turnOn();
        // Подождем, пока адаптер действительно включится
        await FlutterBluePlus.adapterState
            .where((state) => state == BluetoothAdapterState.on)
            .first;
        log('Bluetooth is now on.');
      } else {
        log('Bluetooth is already on.');
      }
    }
  }

  Future<Stream<BluetoothAdapterState>> _getBlueAdapterStream() async {
    if (!await FlutterBluePlus.isSupported) {
      log('Bluetooth not supported by this device');
      throw Exception('Bluetooth not supported by this device');
    }
    await _turnOnBlue();
    return FlutterBluePlus.adapterState;
  }

  Future<BluetoothDevice?> findDeviceFromName(String targetDeviceName) async {
    StreamSubscription<List<ScanResult>>? scanSubscription;
    Completer<BluetoothDevice> deviceCompleter = Completer<BluetoothDevice>();

    try {
      final adapterStream = await _getBlueAdapterStream();
      BluetoothAdapterState currentState = await adapterStream.first;

      if (currentState != BluetoothAdapterState.on) {
        log('Bluetooth is not on. Current state: $currentState');
        throw Exception('Bluetooth is off!');
      }

      log('Starting scan for device: $targetDeviceName...');
      // Таймаут для сканирования устанавливается здесь
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 15),
        // withKeywords: [targetDeviceName], // Можно использовать для фильтрации на уровне ОС, если поддерживается
      );

      scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          for (ScanResult result in results) {
            // Используем localName, platformName или advName
            String currentDeviceName =
                result.device.platformName.isNotEmpty
                    ? result.device.platformName
                    : result.device.localName.isNotEmpty
                    ? result.device.localName
                    : result.advertisementData.advName;

            if (currentDeviceName == targetDeviceName) {
              log(
                'Device found: ${result.device.platformName} (${result.device.remoteId})',
              );
              if (!deviceCompleter.isCompleted) {
                deviceCompleter.complete(result.device);
              }
              // Не останавливаем скан здесь, пусть startScan завершится по таймауту
              // или мы его остановим в finally после получения устройства.
              // FlutterBluePlus.stopScan(); // Лучше остановить после получения результата из completer
              // scanSubscription?.cancel();
              break;
            }
          }
        },
        onDone: () {
          // Вызывается, когда стрим закрыт (например, по таймауту startScan)
          if (!deviceCompleter.isCompleted) {
            log(
              'Scan completed. Device $targetDeviceName not found via onDone.',
            );
            deviceCompleter.completeError(
              Exception(
                'Device $targetDeviceName not found after scan finished.',
              ),
            );
          }
        },
        onError: (error) {
          if (!deviceCompleter.isCompleted) {
            log('Error during scan subscription: $error');
            deviceCompleter.completeError(error);
          }
        },
      );

      // Ожидание результата от Completer с дополнительным таймаутом
      BluetoothDevice device = await deviceCompleter.future.timeout(
        const Duration(seconds: 20), // Общий таймаут на весь процесс поиска
        onTimeout: () {
          log('Timeout waiting for device $targetDeviceName from completer.');
          throw Exception(
            'Timeout: No device with name $targetDeviceName found!',
          );
        },
      );
      return device;
    } catch (e) {
      log('Error in findDeviceFromName for $targetDeviceName: $e');
      return null;
    } finally {
      // Гарантированная остановка сканирования и отписка
      if (FlutterBluePlus.isScanningNow) {
        log('Stopping scan in finally block for findDeviceFromName...');
        await FlutterBluePlus.stopScan();
      }
      await scanSubscription?.cancel();
      log('Scan subscription canceled in finally block.');
    }
  }

  Future<BluetoothService?> findServiceFromDevice(
    BluetoothDevice device,
  ) async {
    try {
      log('Connecting to ${device.platformName} (${device.remoteId})...');
      // Таймаут для подключения, чтобы не зависнуть навсегда
      await device.connect(
        timeout: const Duration(seconds: 15),
        autoConnect: false,
      );
      log('Connected to ${device.platformName}. Discovering services...');

      List<BluetoothService> services = await device.discoverServices();
      log('Found ${services.length} services.');

      final service = services.firstWhere(
        (s) => s.uuid.toString().toLowerCase() == serviceUuid.toLowerCase(),
        orElse: () {
          log(
            'Service with UUID $serviceUuid not found on device ${device.platformName}.',
          );
          throw Exception("Service $serviceUuid not found");
        },
      );
      log('Service $serviceUuid found.');
      return service;
    } catch (e) {
      log('Error in findServiceFromDevice for ${device.platformName}: $e');
      // Важно отсоединиться при любой ошибке на этом этапе
      if (device.isConnected) {
        await device.disconnect();
        log('Disconnected from ${device.platformName} due to error.');
      }
      return null;
    }
  }

  BluetoothCharacteristic? findCharacteristicFromService(
    BluetoothService service,
    String characteristicId,
  ) {
    try {
      final characteristic = service.characteristics.firstWhere(
        (c) =>
            c.uuid.toString().toLowerCase() == characteristicId.toLowerCase(),
      );
      log('Characteristic $characteristicId found in service ${service.uuid}.');
      return characteristic;
    } catch (e) {
      // firstWhere без orElse бросает StateError, если элемент не найден
      log(
        'Characteristic $characteristicId not found in service ${service.uuid}. Error: $e',
      );
      return null;
    }
  }

  Uint8List prepareAndSendIdentifyRequest(String tokenValue) {
    IdentifyRequest request = IdentifyRequest()..token = tokenValue;
    Uint8List dataToSend = request.writeToBuffer();
    log(
      "Prepared IdentifyRequest: Token=$tokenValue, Bytes=$dataToSend, Size=${dataToSend.lengthInBytes} bytes",
    );
    return dataToSend;
  }

  /// Готовит сериализованные байты для ClientMessage с командой SetState.
  ///
  /// [stateToSet]: Значение из enum States, которое необходимо установить.
  Uint8List prepareSetStateCommand(States stateToSet) {
    ClientMessage clientMessage = ClientMessage();

    // ИСПРАВЛЕНИЕ: Используем переданный stateToSet
    clientMessage.setState = SetState(state: stateToSet);

    Uint8List bytesToSend = clientMessage.writeToBuffer();
    log(
      'Prepared ClientMessage (SetState: ${stateToSet.name}): Bytes=$bytesToSend, Size=${bytesToSend.lengthInBytes} bytes',
    );
    return bytesToSend;
  }

  // Вспомогательная функция для подготовки ClientMessage с GetState
  Uint8List prepareGetStateCommandProto() {
    // Переименовал, чтобы не конфликтовать с prepareSetStateCommand
    ClientMessage clientMessage = ClientMessage();
    clientMessage.getState = GetState(); // GetState - пустой тип
    Uint8List bytesToSend = clientMessage.writeToBuffer();
    log(
      'Prepared ClientMessage (GetState): Bytes=$bytesToSend, Size=${bytesToSend.lengthInBytes} bytes',
    );
    return bytesToSend;
  }

  // В классе BlueManager

  // ... (существующие функции) ...

  Uint8List prepareGetStateCommand() {
    ClientMessage clientMessage = ClientMessage();
    clientMessage.getState = GetState(); // GetState - пустое сообщение

    Uint8List bytesToSend = clientMessage.writeToBuffer();
    log(
      'Prepared ClientMessage (GetState): Bytes=$bytesToSend, Size=${bytesToSend.lengthInBytes} bytes',
    );
    return bytesToSend;
  }

  Uint8List prepareGetInfoCommand() {
    ClientMessage clientMessage = ClientMessage();
    clientMessage.getInfo = GetInfo(); // GetInfo - пустое сообщение

    Uint8List bytesToSend = clientMessage.writeToBuffer();
    log(
      'Prepared ClientMessage (GetInfo): Bytes=$bytesToSend, Size=${bytesToSend.lengthInBytes} bytes',
    );
    return bytesToSend;
  }

  Future<void> justTestFunc() async {
    BluetoothDevice? device;
    StreamSubscription<List<int>>? notificationSubscription;

    try {
      log('Starting justTestFunc...');
      // ... (поиск устройства, сервиса, характеристики токена, запись токена - без изменений) ...
      device = await findDeviceFromName(deviceName);

      if (device == null) {
        log('Device $deviceName not found. Exiting test function.');
        return;
      }
      log('Device ${device.platformName} (${device.remoteId}) found.');

      final service = await findServiceFromDevice(device);
      if (service == null) {
        log('Service $serviceUuid not found on device. Exiting test function.');
        return;
      }
      log('Service ${service.uuid} found.');

      final tokenCharacteristic = findCharacteristicFromService(
        service,
        characteristicTokenUuid,
      );
      if (tokenCharacteristic == null) {
        log(
          'Token characteristic $characteristicTokenUuid not found. Exiting test function.',
        );
        return;
      }
      log('Token characteristic ${tokenCharacteristic.uuid} found.');

      final identifyBytes = prepareAndSendIdentifyRequest(
        "CE0HOsYGo2oS8sdF", // Пример токена
      );
      log('Writing token to ${tokenCharacteristic.uuid}...');
      await tokenCharacteristic.write(identifyBytes, withoutResponse: false);
      log('Token written successfully.');

      await Future.delayed(const Duration(milliseconds: 500));

      final commandCharacteristic = findCharacteristicFromService(
        service,
        characteristicUuid,
      );
      if (commandCharacteristic == null) {
        log(
          'Command characteristic $characteristicUuid not found. Exiting test function.',
        );
        return;
      }
      log('Command characteristic ${commandCharacteristic.uuid} found.');

      // Настройка уведомлений (остается без изменений)
      if (commandCharacteristic.properties.notify) {
        log(
          'Setting notify value for command characteristic ${commandCharacteristic.uuid}...',
        );
        await commandCharacteristic.setNotifyValue(true);
        log('Notify value set. Listening for notifications...');

        notificationSubscription = commandCharacteristic.onValueReceived.listen(
          (value) {
            if (value.isEmpty) {
              log('Notification: Received empty value.');
              return;
            }
            try {
              final decoded = ControllerResponse.fromBuffer(value);
              log('Notification: Decoded: ${decoded.toString()}, Raw: $value');
            } catch (e) {
              log('Notification: Error decoding: $e. Raw value: $value');
            }
          },
          onError: (error) {
            log('Error in notification subscription: $error');
          },
        );
        // Используй правильный метод для отмены подписки для твоей версии flutter_blue_plus
        // notificationSubscription.cancelWith(device); // для новых версий
        // device.cancelWhenDisconnected(notificationSubscription); // для старых
        // или отменяй вручную в finally, если не уверен.
        // В твоем коде было просто .cancel(), что не очень хорошо, т.к. отменит сразу.
        // Оставим пока так, но имей в виду, что это отменит подписку сразу после ее создания.
        // ЛУЧШЕ ЗАКОММЕНТИРОВАТЬ ЭТОТ CANCEL ЗДЕСЬ, И ОТМЕНЯТЬ В FINALLY ИЛИ ЧЕРЕЗ cancelWith(device)
        // notificationSubscription.cancel(); // <--- ЭТО ОТМЕНИТ ПОДПИСКУ НЕМЕДЛЕННО!
        log(
          'Notification subscription configured.', // Изменено сообщение
        );
      } else {
        log(
          'Command characteristic ${commandCharacteristic.uuid} does not support notifications.',
        );
      }

      await Future.delayed(const Duration(seconds: 1));

      // --- Тестирование GET INFO (если отправляется как команда) ---
      log('--- Testing GetInfo command ---');
      final bytesGetInfo = prepareGetInfoCommand();
      log('Sending GetInfo command...');
      await commandCharacteristic.write(bytesGetInfo, withoutResponse: false);
      log(
        'GetInfo command sent. Check notifications for ControllerResponse.info.',
      );
      await Future.delayed(const Duration(seconds: 3)); // Даем время на ответ

      // --- Тестирование GET STATE (если отправляется как команда) ---
      log('--- Testing GetState command ---');
      final bytesGetState = prepareGetStateCommand();
      log('Sending GetState command...');
      await commandCharacteristic.write(bytesGetState, withoutResponse: false);
      log(
        'GetState command sent. Check notifications for ControllerResponse.state.',
      );
      await Future.delayed(const Duration(seconds: 3)); // Даем время на ответ

      // --- Тестирование READ характеристики (если она поддерживает read) ---
      if (commandCharacteristic.properties.read) {
        log(
          '--- Testing Read characteristic ${commandCharacteristic.uuid} ---',
        );
        try {
          log('Reading characteristic value...');
          List<int> readValue = await commandCharacteristic.read();
          log('Characteristic Read: Raw value = $readValue');
          if (readValue.isNotEmpty) {
            try {
              final decoded = ControllerResponse.fromBuffer(readValue);
              log('Characteristic Read: Decoded value = ${decoded.toString()}');
            } catch (e) {
              log('Characteristic Read: Error decoding read value: $e');
            }
          } else {
            log('Characteristic Read: Received empty value.');
          }
        } catch (e) {
          log('Error reading characteristic: $e');
        }
        await Future.delayed(const Duration(seconds: 3));
      } else {
        log(
          'Characteristic ${commandCharacteristic.uuid} does not support read.',
        );
      }

      // --- Тестирование SET STATE команд (остается без изменений) ---
      log('--- Testing SetState Commands ---');

      log('Sending LightOff command...');
      final bytesLightOff = prepareSetStateCommand(States.LightOff);
      await commandCharacteristic.write(bytesLightOff, withoutResponse: false);
      log('LightOff command sent.');
      await Future.delayed(const Duration(seconds: 3));

      log('Sending LightOn command...');
      final bytesLightOn = prepareSetStateCommand(States.LightOn);
      await commandCharacteristic.write(bytesLightOn, withoutResponse: false);
      log('LightOn command sent.');
      await Future.delayed(const Duration(seconds: 3));

      log('Sending DoorLockOpen command...');
      final bytesDoorOpen = prepareSetStateCommand(States.DoorLockOpen);
      await commandCharacteristic.write(bytesDoorOpen, withoutResponse: false);
      log('DoorLockOpen command sent.');
      await Future.delayed(const Duration(seconds: 3));

      log('Sending DoorLockClose command...');
      final bytesDoorClose = prepareSetStateCommand(States.DoorLockClose);
      await commandCharacteristic.write(bytesDoorClose, withoutResponse: false);
      log('DoorLockClose command sent.');
      await Future.delayed(const Duration(seconds: 3));

      log(
        'Test commands sent. Waiting a bit more for any final notifications...',
      );
      await Future.delayed(const Duration(seconds: 5));
      log('--- Finished Testing Commands ---');
    } catch (e) {
      // ... (обработка ошибок - без изменений) ...
      log('!!! Critical Error in justTestFunc: $e');
      if (e is FlutterBluePlusException) {
        log(
          'FlutterBluePlusException details: Code: ${e.code}, Description: ${e.description}',
        );
      }
      if (e is PlatformException) {
        log(
          'PlatformException details: Code: ${e.code}, Message: ${e.message}, Details: ${e.details}',
        );
      }
    } finally {
      log('justTestFunc finally block executing...');
      // Важно: отмена подписки!
      if (notificationSubscription != null) {
        // Если ты не используешь cancelWith(device) или device.cancelWhenDisconnected,
        // то нужно отменить подписку здесь, чтобы избежать утечек.
        await notificationSubscription.cancel();
        log('Notification subscription explicitly canceled in finally.');
      }

      // ... (отключение от устройства и остановка сканирования - без изменений) ...
      if (device != null && device.isConnected) {
        log(
          'Disconnecting from ${device.platformName} (${device.remoteId}) in finally block...',
        );
        try {
          await device.disconnect();
          log('Disconnected successfully.');
        } catch (disconnectError) {
          log('Error during disconnection: $disconnectError');
        }
      } else if (device != null) {
        log(
          'Device ${device.platformName} was found but is not connected in finally block (or already disconnected).',
        );
      } else {
        log('Device was not found or initialized, no disconnection needed.');
      }

      if (FlutterBluePlus.isScanningNow) {
        log(
          'Stopping scan in finally block of justTestFunc (should have stopped earlier)...',
        );
        await FlutterBluePlus.stopScan();
      }
      log('Finished justTestFunc execution.');
    }
  }

  // Свойство для получения стрима результатов сканирования, если нужно извне
  Stream<List<ScanResult>> get scanResultsStream => FlutterBluePlus.scanResults;
}
