import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';

class HotelPrimaryButton extends StatelessWidget {
  const HotelPrimaryButton({
    super.key,
    required this.title,
    this.color,
    this.icon,
  });

  final String title;
  final Color? color;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? AppColors.main,
        borderRadius: BorderRadius.circular(25),
      ),
      height: 52,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 31),
      child: icon != null ? _buildWithIcon() : _buildWithoutIcon(),
    );
  }

  Widget _buildWithIcon() {
    return Row(
      children: [
        icon!,
        SizedBox(width: 5),
        getGeistText(title, weight: 700, size: 16),
      ],
    );
  }

  Widget _buildWithoutIcon() {
    return Center(child: getGeistText(title, weight: 700, size: 16));
  }
}
