import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/hotel_primary_button.dart';
import 'package:smart_hotel_app/core/widgets/hotel_text_field.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HotelTextField(
              controller: controller,
              hintText: 'Email',
              prefixIconPath: AppIcons.key,
            ),
            HotelPrimaryButton(title: 'Login', color: AppColors.main),
          ],
        ),
      ),
    );
  }
}
