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
  });

  final String title;
  final Color? color;
  final Widget? icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: color ?? AppColors.main,
          borderRadius: BorderRadius.circular(25),
        ),
        height: 52,
        width: double.infinity,
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
        getGeistText(title, weight: 500, size: 16),
      ],
    );
  }

  Widget _buildWithoutIcon() {
    return Center(child: getGeistText(title, weight: 700, size: 16));
  }
}
