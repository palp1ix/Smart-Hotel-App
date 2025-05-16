import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/managers/blue_manager.dart';
import 'package:smart_hotel_app/router/router.dart';

void main() async {
  runApp(const HotelApp());
  final blueManager = BlueManager(
    deviceName: "ROOM_18",
    serviceUuid: "1807",
    characteristicUuid: "2A11",
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
