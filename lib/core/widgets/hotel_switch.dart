import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/widgets/hotel_icon_switch.dart';

class HotelSwitch extends StatefulWidget {
  const HotelSwitch({
    super.key,
    required this.isSelected,
    required this.onSelect,
  });
  final bool isSelected;
  final VoidCallback onSelect;

  @override
  State<HotelSwitch> createState() => _HotelSwitchState();
}

class _HotelSwitchState extends State<HotelSwitch> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31,
      width: 60,
      decoration: BoxDecoration(
        color: AppColors.onContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: AnimatedAlign(
        curve: Curves.easeInOut,
        duration: const Duration(milliseconds: 200),
        alignment:
            widget.isSelected ? Alignment.centerRight : Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: HotelIconSwitch(
            isSelected: widget.isSelected,
            onSelect: () => widget.onSelect(),
            onUnSelect: () => widget.onSelect(),
            iconPath: 'assets/icons/power.svg',
            size: 25,
          ),
        ),
      ),
    );
  }
}
