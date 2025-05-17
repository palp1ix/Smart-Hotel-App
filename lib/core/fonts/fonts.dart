import 'package:flutter/material.dart';

Text getGeistText(
  String text, {
  double? weight,
  Color? color,
  double? size,
  TextOverflow? overflow,
  int? maxLines,
}) {
  return Text(
    overflow: overflow,
    maxLines: maxLines,
    text,
    style: TextStyle(
      color: color ?? Colors.white,
      fontSize: size,
      fontVariations: weight != null ? [FontVariation('wght', weight)] : null,
    ),
  );
}
