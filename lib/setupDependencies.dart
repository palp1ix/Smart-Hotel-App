import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smart_hotel_app/managers/auth_service.dart';
import 'package:smart_hotel_app/managers/blue_manager.dart';

final serviceLocator = GetIt.instance;

Future<void> setupDependencies() async {
  final authManager = AuthService();
  final dio = Dio();
  final blueManager = BlueManager(
    deviceName: "ROOM_28",
    serviceUuid: "00FF",
    characteristicUuid: "ff01",
    characteristicTokenUuid: "ff02",
    authToken: "CE0HOsYGo2oS8sdF",
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await authManager.storage.getAccessToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  serviceLocator.registerSingleton(blueManager);
  serviceLocator.registerSingleton(dio);
}
