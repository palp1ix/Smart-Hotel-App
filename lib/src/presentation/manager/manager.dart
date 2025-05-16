import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart' show AppColors;
import 'package:smart_hotel_app/core/widgets/widgets.dart';

@RoutePage()
class ManagerScreen extends StatefulWidget {
  const ManagerScreen({super.key});

  @override
  State<ManagerScreen> createState() => _ManagerScreenState();
}

class _ManagerScreenState extends State<ManagerScreen> {
  final List<String> _labels = ['Living room', 'Bedroom', 'Kitchen'];

  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        surfaceTintColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Flexible(
              child: HotelToggleButtons(
                selectedIndex: _selectedIndex,
                labels: _labels,
                onPressed: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            HotelCircleSelector(),
          ],
        ),
      ),
    );
  }
}
