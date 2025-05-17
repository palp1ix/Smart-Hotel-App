import 'package:get_it/get_it.dart';
import 'package:smart_hotel_app/managers/blue_manager.dart';

final serviceLocator = GetIt.instance;

Future<void> setupDependencies() async {
  final blueManager = BlueManager(
    deviceName: "ROOM_28",
    serviceUuid: "00FF",
    characteristicUuid: "ff01",
    characteristicTokenUuid: "ff02",
    authToken: "CE0HOsYGo2oS8sdF",
  );

  serviceLocator.registerSingleton(blueManager);
}
