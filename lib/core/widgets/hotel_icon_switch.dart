import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';

class HotelIconSwitch extends StatefulWidget {
  const HotelIconSwitch({
    super.key,
    this.size = 25,
    required this.onSelect,
    required this.onUnSelect,
    required this.iconPath,
    this.isSelected = false,
  });

  final double size;
  final VoidCallback onSelect;
  final VoidCallback onUnSelect;
  final String iconPath;
  final bool isSelected;

  @override
  State<HotelIconSwitch> createState() => _HotelIconSwitchState();
}

class _HotelIconSwitchState extends State<HotelIconSwitch> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.isSelected;

    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });

        if (isSelected) {
          widget.onSelect();
        } else {
          widget.onUnSelect();
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? AppColors.main : AppColors.container,
        ),
        child: Padding(
          padding: EdgeInsets.all(5),
          child: SvgPicture.asset(widget.iconPath),
        ),
      ),
    );
  }
}
