import 'package:flutter/material.dart';

class HotelTextField extends StatefulWidget {
  const HotelTextField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  final TextEditingController controller;
  final String hintText;

  @override
  State<HotelTextField> createState() => _HotelTextFieldState();
}

class _HotelTextFieldState extends State<HotelTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.red, width: 4),
        ),
      ),
    );
  }
}
