import 'package:flutter/material.dart';
import 'package:smart_hotel_app/router/router.dart';

void main() async {
  runApp(const HotelApp());
}

class HotelApp extends StatelessWidget {
  const HotelApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter();

    return MaterialApp.router(
      routerConfig: router.config(),
      theme: ThemeData(fontFamily: 'Geist'),
    );
  }
}
