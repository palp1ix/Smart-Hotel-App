import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data'; // For Uint8List

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:protobuf/protobuf.dart'; // Для GeneratedMessage
// Убедитесь, что путь к вашему protobuf файлу правильный
import 'package:smart_hotel_app/core/protobuf/device_commands.pb.dart'; // Предполагаемый путь

// Enum for feedback status (без изменений)
enum BleOperationStatus {
  idle,
  bluetoothTurningOn,
  bluetoothOn,
  scanning,
  deviceFound,
  connecting,
  connected,
  servicesDiscovered,
  characteristicsFound,
  sendingToken,
  tokenSent,
  sendingCommand,
  commandSent,
  operationSuccess,
  operationFailed,
  dataReceived,
  disconnected,
  error,
}

// Class for feedback data (без изменений)
class BleFeedback {
  final BleOperationStatus status;
  final String? message;
  final dynamic data;

  BleFeedback({required this.status, this.message, this.data});

  @override
  String toString() {
    return 'BleFeedback(status: $status, message: $message, data: $data)';
  }
}

class BlueManager {
  // Конструктор и поля (без изменений)
  BlueManager({
    required this.deviceName,
    required this.serviceUuid,
    required this.characteristicTokenUuid,
    required this.characteristicUuid,
    required this.authToken,
  }) {
    _adapterStateSubscription = FlutterBluePlus.adapterState.listen((state) {
      log('Bluetooth Adapter State Changed: $state');
      if (state == BluetoothAdapterState.on) {
        _feedbackController.add(
          BleFeedback(status: BleOperationStatus.bluetoothOn),
        );
      } else {
        _resetState(notify: true, reason: "Bluetooth adapter turned off");
      }
    });
  }

  final String deviceName;
  final String serviceUuid;
  final String characteristicTokenUuid;
  final String characteristicUuid;
  final String authToken;

  BluetoothDevice? _targetDevice;
  BluetoothCharacteristic? _tokenCharacteristic;
  BluetoothCharacteristic? _commandCharacteristic;

  StreamSubscription<BluetoothConnectionState>? _connectionStateSubscription;
  StreamSubscription<List<int>>? _notificationSubscription;
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  bool _isInitialized = false;
  bool _isInitializing = false;

  final StreamController<BleFeedback> _feedbackController =
      StreamController<BleFeedback>.broadcast();
  Stream<BleFeedback> get feedbackStream => _feedbackController.stream;

  // _turnOnBlue (без изменений)
  Future<void> _turnOnBlue() async {
    if (!kIsWeb && Platform.isAndroid) {
      if (FlutterBluePlus.adapterStateNow != BluetoothAdapterState.on) {
        _feedbackController.add(
          BleFeedback(
            status: BleOperationStatus.bluetoothTurningOn,
            message: "Attempting to turn on Bluetooth...",
          ),
        );
        log('Bluetooth is off. Turning it on...');
        try {
          await FlutterBluePlus.turnOn(timeout: 10);
          await FlutterBluePlus.adapterState
              .where((state) => state == BluetoothAdapterState.on)
              .first
              .timeout(
                const Duration(seconds: 10),
                onTimeout: () {
                  log(
                    "Timeout waiting for Bluetooth to turn on (stream confirmation in _turnOnBlue).",
                  );
                  throw Exception(
                    "Timeout waiting for Bluetooth to turn on (stream confirmation).",
                  );
                },
              );
          log('Bluetooth is now on (confirmed by _turnOnBlue internal wait).');
        } catch (e) {
          log('Error during _turnOnBlue: $e');
          rethrow;
        }
      } else {
        log('Bluetooth is already on (checked by _turnOnBlue).');
      }
    }
  }

  // _ensureInitialized (используем версию с правильным порядком токена и уведомлений)
  Future<void> _ensureInitialized() async {
    if (_isInitialized) return;
    if (_isInitializing) {
      log("_ensureInitialized: Already initializing, waiting...");
      await Future.doWhile(() => _isInitializing && !_isInitialized);
      if (_isInitialized) return;
      log("_ensureInitialized: Previous initialization finished, proceeding.");
    }

    _isInitializing = true;

    try {
      // 0. Check Bluetooth support first
      if (!await FlutterBluePlus.isSupported) {
        final msg = 'Bluetooth not supported by this device';
        log(msg);
        _feedbackController.add(
          BleFeedback(status: BleOperationStatus.error, message: msg),
        );
        throw Exception(msg);
      }

      // 1. Attempt to turn on Bluetooth
      await _turnOnBlue();

      // 2. Robustly verify Bluetooth is ON
      BluetoothAdapterState currentAdapterState =
          FlutterBluePlus.adapterStateNow;
      if (currentAdapterState != BluetoothAdapterState.on) {
        log(
          'Bluetooth adapter state is $currentAdapterState immediately after _turnOnBlue. Waiting for stream confirmation...',
        );
        try {
          currentAdapterState = await FlutterBluePlus.adapterState
              .where((state) => state == BluetoothAdapterState.on)
              .first
              .timeout(
                const Duration(seconds: 5),
                onTimeout: () {
                  log(
                    'Timeout waiting for Bluetooth adapter to confirm ON via stream. Last known: ${FlutterBluePlus.adapterStateNow}',
                  );
                  throw Exception(
                    'Timeout waiting for Bluetooth adapter to confirm ON.',
                  );
                },
              );
          log('Bluetooth Adapter confirmed ON via stream after explicit wait.');
        } catch (e) {
          final msg =
              'Failed to confirm Bluetooth is ON: $e. Current adapterStateNow: ${FlutterBluePlus.adapterStateNow}';
          log(msg);
          _feedbackController.add(
            BleFeedback(status: BleOperationStatus.error, message: msg),
          );
          throw Exception(msg);
        }
      }
      if (currentAdapterState != BluetoothAdapterState.on) {
        final msg =
            'Bluetooth is not ON after all checks (State: $currentAdapterState). Cannot proceed.';
        log(msg);
        _feedbackController.add(
          BleFeedback(status: BleOperationStatus.error, message: msg),
        );
        throw Exception(msg);
      }
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.bluetoothOn,
          message: "Bluetooth confirmed ON.",
        ),
      );
      log('Proceeding with initialization: Bluetooth is ON.');

      // 3. Find device
      if (_targetDevice == null || !_targetDevice!.isConnected) {
        await _connectionStateSubscription?.cancel();
        _targetDevice = await _findDevice();
        if (_targetDevice == null)
          throw Exception('Device $deviceName not found.');
      }

      // 4. Connect to device
      if (!_targetDevice!.isConnected) {
        _feedbackController.add(
          BleFeedback(
            status: BleOperationStatus.connecting,
            message: 'Connecting to ${deviceName}...',
          ),
        );
        await _targetDevice!.connect(
          timeout: const Duration(seconds: 15),
          autoConnect: false,
        );
        _feedbackController.add(
          BleFeedback(
            status: BleOperationStatus.connected,
            message: 'Connected to ${deviceName}',
          ),
        );
        _listenToConnectionChanges();
      } else {
        _feedbackController.add(
          BleFeedback(
            status: BleOperationStatus.connected,
            message: 'Already connected to ${deviceName}',
          ),
        );
        _listenToConnectionChanges();
      }

      // 5. Discover services and characteristics
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.servicesDiscovered,
          message: 'Discovering services...',
        ),
      );
      List<BluetoothService> services = await _targetDevice!.discoverServices(
        timeout: 15,
      );
      log('Found ${services.length} services.');
      final service = services.firstWhere(
        (s) => s.uuid.toString().toLowerCase() == serviceUuid.toLowerCase(),
        orElse: () => throw Exception("Service $serviceUuid not found"),
      );
      log('Service $serviceUuid found.');
      _tokenCharacteristic = service.characteristics.firstWhere(
        (c) =>
            c.uuid.toString().toLowerCase() ==
            characteristicTokenUuid.toLowerCase(),
        orElse:
            () =>
                throw Exception(
                  "Token characteristic $characteristicTokenUuid not found",
                ),
      );
      log('Token characteristic ${_tokenCharacteristic!.uuid} found.');
      _commandCharacteristic = service.characteristics.firstWhere(
        (c) =>
            c.uuid.toString().toLowerCase() == characteristicUuid.toLowerCase(),
        orElse:
            () =>
                throw Exception(
                  "Command characteristic $characteristicUuid not found",
                ),
      );
      log('Command characteristic ${_commandCharacteristic!.uuid} found.');
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.characteristicsFound,
          message: "Required characteristics found.",
        ),
      );

      // 6. Send token
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.sendingToken,
          message: "Sending identification token...",
        ),
      );
      final identifyBytes = prepareAndSendIdentifyRequest(
        authToken,
      ); // ЗАМЕНИТЕ ТОКЕН
      await _tokenCharacteristic!.write(
        identifyBytes,
        withoutResponse: false,
      ); // ПРОВЕРЬТЕ withoutResponse
      log('Token written successfully.');

      // 7. Set up notifications on command characteristic
      if (_commandCharacteristic!.properties.notify) {
        if (!_commandCharacteristic!.isNotifying) {
          log(
            "Setting notify value for command characteristic AFTER token sent...",
          );
          await _commandCharacteristic!.setNotifyValue(true);
          log("Notify value set successfully for command characteristic.");
        } else {
          log("Command characteristic already notifying.");
        }
        _listenToNotifications();
      } else {
        log('Command characteristic does not support notifications.');
      }

      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.tokenSent,
          message: 'Device initialized and ready.',
        ),
      );
      _isInitialized = true;
    } catch (e, s) {
      log('Error during initialization: $e\nStack: $s');
      if (!_feedbackController.isClosed && _feedbackController.hasListener) {
        _feedbackController.add(
          BleFeedback(
            status: BleOperationStatus.error,
            message: 'Initialization failed: ${e.toString()}',
          ),
        );
      }
      await _resetState(notify: false);
      rethrow;
    } finally {
      _isInitializing = false;
    }
  }

  // _getBlueAdapterStream (без изменений)
  Future<Stream<BluetoothAdapterState>> _getBlueAdapterStream() async {
    if (!await FlutterBluePlus.isSupported) {
      log('Bluetooth not supported by this device');
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.error,
          message: 'Bluetooth not supported',
        ),
      );
      throw Exception('Bluetooth not supported by this device');
    }
    await _turnOnBlue();
    return FlutterBluePlus.adapterState;
  }

  // _findDevice (без изменений)
  Future<BluetoothDevice?> _findDevice() async {
    StreamSubscription<List<ScanResult>>? scanSubscription;
    Completer<BluetoothDevice> deviceCompleter = Completer<BluetoothDevice>();
    try {
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.scanning,
          message: 'Scanning for $deviceName...',
        ),
      );
      final adapterStream = await _getBlueAdapterStream();
      BluetoothAdapterState currentState = await adapterStream.first;
      if (currentState != BluetoothAdapterState.on) {
        log('Bluetooth is not on. Current state: $currentState');
        throw Exception('Bluetooth is off!');
      }
      log('Starting scan for device: $deviceName...');
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      scanSubscription = FlutterBluePlus.scanResults.listen(
        (results) {
          for (ScanResult result in results) {
            String currentDeviceName =
                result.device.platformName.isNotEmpty
                    ? result.device.platformName
                    : result.device.localName.isNotEmpty
                    ? result.device.localName
                    : result.advertisementData.advName;
            if (currentDeviceName == deviceName) {
              log(
                'Device found: ${result.device.platformName} (${result.device.remoteId})',
              );
              if (!deviceCompleter.isCompleted)
                deviceCompleter.complete(result.device);
              break;
            }
          }
        },
        onDone: () {
          if (!deviceCompleter.isCompleted) {
            log('Scan completed. Device $deviceName not found via onDone.');
            deviceCompleter.completeError(
              Exception('Device $deviceName not found after scan finished.'),
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
      BluetoothDevice device = await deviceCompleter.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          log('Timeout waiting for device $deviceName from completer.');
          throw Exception('Timeout: No device with name $deviceName found!');
        },
      );
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.deviceFound,
          message: 'Device $deviceName found',
        ),
      );
      return device;
    } catch (e) {
      log('Error in _findDevice for $deviceName: $e');
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.error,
          message: 'Failed to find device: $e',
        ),
      );
      return null;
    } finally {
      if (FlutterBluePlus.isScanningNow) await FlutterBluePlus.stopScan();
      await scanSubscription?.cancel();
    }
  }

  // _listenToConnectionChanges (без изменений)
  void _listenToConnectionChanges() {
    _connectionStateSubscription?.cancel();
    _connectionStateSubscription = _targetDevice!.connectionState.listen((
      state,
    ) {
      log('Device ${_targetDevice?.platformName} connection state: $state');
      if (state == BluetoothConnectionState.disconnected) {
        _feedbackController.add(
          BleFeedback(
            status: BleOperationStatus.disconnected,
            message: 'Device disconnected',
          ),
        );
        _resetState(notify: false);
      } else if (state == BluetoothConnectionState.connected) {
        log('Device re-confirmed connected.');
      }
    });
  }

  // _listenToNotifications (без изменений)
  void _listenToNotifications() {
    _notificationSubscription?.cancel();
    if (_commandCharacteristic == null ||
        !_commandCharacteristic!.properties.notify) {
      log('Command characteristic is null or does not support notifications.');
      return;
    }
    _notificationSubscription = _commandCharacteristic!.onValueReceived.listen(
      (value) {
        if (value.isEmpty) {
          log('Notification: Received empty value.');
          return;
        }
        try {
          final decoded = ControllerResponse.fromBuffer(value);
          log('Notification: Decoded: ${decoded.status.name}, Raw: $value');
          if (decoded.hasState()) {
            _feedbackController.add(
              BleFeedback(
                status: BleOperationStatus.dataReceived,
                message: 'State received: ${decoded.state}',
                data: decoded.state,
              ),
            );
          } else if (decoded.hasInfo()) {
            _feedbackController.add(
              BleFeedback(
                status: BleOperationStatus.dataReceived,
                message: 'Info received: ${decoded.info}',
                data: decoded.info,
              ),
            );
          } else {
            // Общий успешный ответ, если не было конкретных данных
            _feedbackController.add(
              BleFeedback(
                status: BleOperationStatus.operationSuccess,
                message: 'Operation confirmed by device notification.',
                data: decoded,
              ),
            );
          }
        } catch (e) {
          log('Notification: Error decoding: $e. Raw value: $value');
          _feedbackController.add(
            BleFeedback(
              status: BleOperationStatus.error,
              message: 'Error decoding notification: $e. Raw: $value',
            ),
          );
        }
      },
      onError: (error) {
        log('Error in notification subscription: $error');
        _feedbackController.add(
          BleFeedback(
            status: BleOperationStatus.error,
            message: 'Notification error: $error',
          ),
        );
      },
    );
    log(
      'Notification subscription configured for ${_commandCharacteristic!.uuid}.',
    );
  }

  // ИЗМЕНЕННЫЙ _sendCommand: принимает GeneratedMessage
  Future<void> _sendCommand(
    GeneratedMessage commandMessage, { // Принимаем базовый класс Protobuf
    String? operationDescription,
  }) async {
    await _ensureInitialized();

    if (_commandCharacteristic == null) {
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.error,
          message: 'Command characteristic not available.',
        ),
      );
      throw Exception('Command characteristic not available.');
    }

    // Сериализуем переданное сообщение напрямую
    final Uint8List bytesToSend = commandMessage.writeToBuffer();
    String messageType = commandMessage.runtimeType.toString();
    log(
      'Sending $messageType (${operationDescription ?? "command"}): Bytes=$bytesToSend, Size=${bytesToSend.lengthInBytes}',
    );
    _feedbackController.add(
      BleFeedback(
        status: BleOperationStatus.sendingCommand,
        message: 'Sending ${operationDescription ?? messageType}...',
      ),
    );

    try {
      await _commandCharacteristic!.write(
        bytesToSend,
        withoutResponse: false,
      ); // Убедитесь, что withoutResponse правильный
      log(
        '${operationDescription ?? messageType} sent. Awaiting notification for confirmation.',
      );
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.commandSent,
          message: '${operationDescription ?? messageType} sent.',
        ),
      );

      try {
        final value = await _commandCharacteristic!.read();
        final decoded = ControllerResponse.fromBuffer(value);
        log('Command response: ${decoded.status.name}, Raw: $value');
      } on Exception catch (e) {
        log('Error reading command response: $e');
      }
    } catch (e) {
      log('Error writing command: $e');
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.error,
          message: 'Failed to send command: $e',
        ),
      );
      rethrow;
    }
  }

  // _resetState (без изменений)
  Future<void> _resetState({bool notify = true, String? reason}) async {
    log('Resetting BlueManager state. Reason: ${reason ?? "N/A"}');
    _isInitialized = false;
    _isInitializing = false;
    await _notificationSubscription?.cancel();
    _notificationSubscription = null;
    await _connectionStateSubscription?.cancel();
    _connectionStateSubscription = null;
    if (_targetDevice != null && _targetDevice!.isConnected) {
      try {
        await _targetDevice!.disconnect();
        log('Disconnected from ${_targetDevice!.platformName} during reset.');
      } catch (e) {
        log('Error disconnecting during reset: $e');
      }
    }
    _targetDevice = null;
    _tokenCharacteristic = null;
    _commandCharacteristic = null;
    if (notify && !_feedbackController.isClosed) {
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.idle,
          message: "State reset. ${reason ?? ""}",
        ),
      );
    }
  }

  // --- Public API Methods ---
  // ИЗМЕНЕНЫ для отправки конкретных Protobuf сообщений

  Future<void> turnLightOn() async {
    final command = SetState()..state = States.LightOn;
    await _sendCommand(command, operationDescription: 'Turn Light On');
  }

  Future<void> turnLightOff() async {
    final command = SetState()..state = States.LightOff;
    await _sendCommand(command, operationDescription: 'Turn Light Off');
  }

  Future<void> openDoor() async {
    final command = SetState()..state = States.DoorLockOpen;
    await _sendCommand(command, operationDescription: 'Open Door');
  }

  Future<void> closeDoor() async {
    final command = SetState()..state = States.DoorLockClose;
    await _sendCommand(command, operationDescription: 'Close Door');
  }

  Future<void> getDeviceState() async {
    final command = GetState(); // Пустое сообщение
    await _sendCommand(command, operationDescription: 'Get Device State');
  }

  Future<void> getDeviceInfo() async {
    final command = GetInfo(); // Пустое сообщение
    await _sendCommand(command, operationDescription: 'Get Device Info');
  }

  // --- Protobuf Helper Methods ---

  // prepareAndSendIdentifyRequest остается таким же, так как он для токена
  Uint8List prepareAndSendIdentifyRequest(String tokenValue) {
    IdentifyRequest request = IdentifyRequest()..token = tokenValue;
    Uint8List dataToSend = request.writeToBuffer();
    log(
      "Prepared IdentifyRequest: Token=$tokenValue, Bytes=$dataToSend, Size=${dataToSend.lengthInBytes} bytes",
    );
    return dataToSend;
  }

  // Вспомогательные методы prepare...Message больше не нужны,
  // так как команды создаются напрямую в публичных методах.
  // Их можно удалить или оставить для справки, если они используются где-то еще.

  // --- Cleanup ---
  Future<void> dispose() async {
    log('Disposing BlueManager...');
    await _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
    await _resetState(notify: false);
    await _feedbackController.close();
    log('BlueManager disposed.');
  }

  // justTestFunc (без изменений, т.к. вызывает публичные методы)
  Future<void> justTestFunc() async {
    log('Starting justTestFunc via BlueManager methods...');
    try {
      _feedbackController.add(
        BleFeedback(status: BleOperationStatus.idle, message: "Test Started"),
      );
      await getDeviceInfo();
      await Future.delayed(const Duration(seconds: 3));
      await getDeviceState();
      await Future.delayed(const Duration(seconds: 3));
      await turnLightOff();
      await Future.delayed(const Duration(seconds: 3));
      await turnLightOn();
      await Future.delayed(const Duration(seconds: 3));
      await openDoor();
      await Future.delayed(const Duration(seconds: 3));
      await closeDoor();
      await Future.delayed(const Duration(seconds: 3));
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.idle,
          message: "Test functions completed. Check logs and UI for feedback.",
        ),
      );
      log('--- Finished Testing Commands via BlueManager ---');
    } catch (e) {
      log('!!! Error in justTestFunc: $e');
      _feedbackController.add(
        BleFeedback(
          status: BleOperationStatus.error,
          message: "Test failed: $e",
        ),
      );
    }
  }
}
