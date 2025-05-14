import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlueManager {
  // Singleton instance
  static final BlueManager _instance = BlueManager._internal();

  // Private constructor
  BlueManager._internal();

  // Factory constructor to return the singleton instance
  factory BlueManager() {
    return _instance;
  }

  // Example method to demonstrate functionality
  Future<void> startScan() async {
    if (await FlutterBluePlus.isSupported == false) {
      log("Bluetooth not supported by this device");
      return;
    }

    FlutterBluePlus.onScanResults.listen((result) {
      for (var result in result) {
        log(
          "Found device: ${result.device.advName} (${result.device.platformName})",
        );
        if (result.device.advName == "Alert Notification") {
          result.device
              .connect()
              .then((_) {
                log("Connected to ${result.device.advName}");
              })
              .catchError((error) {
                log("Failed to connect to ${result.device.advName}: $error");
              });
        }
      }
    });

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
  }

  Stream<List<ScanResult>> get scanResultStream =>
      FlutterBluePlus.onScanResults;
}
