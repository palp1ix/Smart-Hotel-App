import 'package:flutter/material.dart';

Text getGeistText(String text, {double? weight, Color? color, double? size}) {
  return Text(
    text,
    style: TextStyle(
      color: color ?? Colors.white,
      fontSize: size,
      fontVariations: weight != null ? [FontVariation('wght', weight)] : null,
    ),
  );
}
