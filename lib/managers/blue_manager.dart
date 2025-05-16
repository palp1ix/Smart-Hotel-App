import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlueManager {
  BlueManager({
    required this.deviceName,
    required this.serviceUuid,
    required this.characteristicUuid,
  });

  final String deviceName;
  final String serviceUuid;
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
            log('Found device: ${result.device.advName}');
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
    // Ensure we're connected
    await device.connect(autoConnect: false);
    // Slight delay to allow connection
    await Future.delayed(const Duration(milliseconds: 500));

    // Discover services with timeout
    List<BluetoothService> services;
    try {
      services = await device.discoverServices().timeout(
        const Duration(seconds: 10),
      );

      // TODO: Delete test logic!
      services.forEach((service) {
        log('Discovered service: ${service.uuid}');
        service.characteristics.forEach((characteristic) {
          log('Characteristic: ${characteristic.uuid}');
        });
      });
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
  ) {
    return service.characteristics.firstWhere(
      (c) => c.uuid == Guid(characteristicUuid),
      orElse: () {
        log('Characteristic $characteristicUuid not found');
        throw Exception("Error");
      },
    );
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

    final characteristic = findCharacteristicFromService(service);
    if (characteristic == null) {
      log('Characteristic $characteristicUuid not found');
      return;
    }

    final bytes = await characteristic.read();
    log('Read value: $bytes');
    log(utf8.decode(bytes));
    // Disconnect when done
    await device.disconnect();
  }

  Stream<List<ScanResult>> get scanResultStream =>
      FlutterBluePlus.onScanResults;
}
