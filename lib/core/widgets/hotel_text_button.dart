import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';

class HotelTextButton extends StatelessWidget {
  const HotelTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.textColor,
  });

  final VoidCallback onPressed;
  final String text;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStatePropertyAll(textColor ?? AppColors.main),
        overlayColor: WidgetStatePropertyAll(Colors.transparent),
      ),
      child: Text(
        text,
        style: TextStyle(fontVariations: [FontVariation('wght', 600)]),
      ),
    );
  }
}
