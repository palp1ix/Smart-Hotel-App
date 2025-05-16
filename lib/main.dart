import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/managers/blue_manager.dart';
import 'package:smart_hotel_app/router/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const HotelApp());

  final blueManager = BlueManager(
    deviceName: "ROOM_28",
    serviceUuid: "00FF",
    characteristicUuid: "ff01",
    characteristicTokenUuid: "ff02",
  );

  await blueManager.justTestFunc();
}

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router.config(),
      theme: ThemeData(
        fontFamily: 'Geist',
        colorScheme: ColorScheme.dark(surface: AppColors.background),
      ),
    );
  }
}
