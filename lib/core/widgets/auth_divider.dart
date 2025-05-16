import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Divider(color: AppColors.onContainer, height: 2)),
        SizedBox(width: 20),
        getGeistText('Or Sign In With', weight: 500, size: 16),
        SizedBox(width: 20),
        Expanded(child: Divider(color: AppColors.onContainer, height: 2)),
      ],
    );
  }
}
