import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';

class HotelButtonContainer extends StatefulWidget {
  const HotelButtonContainer({
    super.key,
    required this.width,
    required this.height,
    required this.iconPath,
    required this.text,
  });

  final double width;
  final double height;
  final String iconPath;
  final String text;

  @override
  State<HotelButtonContainer> createState() => _HotelButtonContainerState();
}

class _HotelButtonContainerState extends State<HotelButtonContainer> {
  bool isSelected = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: AnimatedContainer(
        width: widget.width,
        height: widget.height,
        duration: Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.background : AppColors.container,
          borderRadius: BorderRadius.circular(15),
          border:
              isSelected ? Border.all(width: 2, color: AppColors.main) : null,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                widget.iconPath,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.main : Colors.white,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(height: 5),
              getGeistText(
                widget.text,
                weight: 550,
                color: isSelected ? AppColors.main : Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
