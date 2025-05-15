import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';

class HotelTextField extends StatefulWidget {
  const HotelTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIconPath,
  });

  final TextEditingController controller;
  final String hintText;
  final String? prefixIconPath;

  @override
  State<HotelTextField> createState() => _HotelTextFieldState();
}

class _HotelTextFieldState extends State<HotelTextField> {
  @override
  Widget build(BuildContext context) {
    final iconPath = widget.prefixIconPath;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 60),
      child: TextField(
        controller: widget.controller,
        cursorColor: Color(0xFF3E5854),
        cursorWidth: 3,
        style: TextStyle(
          fontSize: 16,
          fontVariations: [FontVariation('wght', 600)],
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor:
              AppColors.container, // Choose your desired background color
          hintText: widget.hintText,
          prefixIcon: iconPath != null ? _getIconWidget(iconPath) : null,
          prefixIconConstraints: BoxConstraints(maxWidth: 40),
          hintFadeDuration: Duration(milliseconds: 150),
          hintStyle: TextStyle(
            color: Color(0xFF3E5854),
            fontVariations: [FontVariation('wght', 600)],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15,
            ), // Adjust the radius as needed
            borderSide: BorderSide(
              color: Color(0xFF3E5854), // Color of the border when enabled
              width: 2, // Width of the border
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: AppColors.main, // Color of the border when focused
              width: 2, // Width of the border when focused
            ),
          ),
        ),
      ),
    );
  }

  Widget _getIconWidget(String path) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 10),
      child: SvgPicture.asset(
        path,
        colorFilter: ColorFilter.mode(Color(0xFF3E5854), BlendMode.srcIn),
      ),
    );
  }
}
