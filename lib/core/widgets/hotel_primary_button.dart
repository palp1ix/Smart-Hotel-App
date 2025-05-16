import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';

class HotelPrimaryButton extends StatelessWidget {
  const HotelPrimaryButton({
    super.key,
    required this.title,
    this.color,
    this.icon,
    required this.onPressed,
    this.width,
    this.padding,
    this.margin,
    this.textWeight,
    this.height,
  });

  final String title;
  final Color? color;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? textWeight;
  final Widget? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: padding ?? const EdgeInsets.all(5),
        margin: margin,
        decoration: BoxDecoration(
          color: color ?? AppColors.main,
          borderRadius: BorderRadius.circular(25),
        ),
        height: height ?? 52,
        width: width,
        child: icon != null ? _buildWithIcon() : _buildWithoutIcon(),
      ),
    );
  }

  Widget _buildWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon!,
        SizedBox(width: 10),
        getGeistText(title, weight: textWeight ?? 500, size: 16),
      ],
    );
  }

  Widget _buildWithoutIcon() {
    return Center(
      child: getGeistText(title, weight: textWeight ?? 700, size: 16),
    );
  }
}

class HotelToggleButtons extends StatelessWidget {
  const HotelToggleButtons({
    super.key,
    required this.labels,
    required this.onPressed,
    required this.selectedIndex,
  });

  final List<String> labels;
  final int selectedIndex;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...List.generate(labels.length, (index) {
            return HotelPrimaryButton(
              height: 40,
              textWeight: 480,
              color:
                  selectedIndex == index ? AppColors.main : AppColors.container,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              margin: const EdgeInsets.only(right: 10),
              title: labels[index],
              onPressed: () => onPressed(index),
            );
          }),
        ],
      ),
    );
  }
}
