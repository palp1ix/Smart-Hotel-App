import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/hotel_primary_button.dart';
import 'package:smart_hotel_app/core/widgets/hotel_text_button.dart';
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelTextField(
                controller: controller,
                hintText: 'Email',
                prefixIconPath: AppIcons.atSymbol,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelTextField(
                controller: controller,
                hintText: 'Password',
                prefixIconPath: AppIcons.key,
              ),
            ),
            HotelPrimaryButton(title: 'Login', color: AppColors.main),
            HotelTextButton(onPressed: () {}, text: 'Some text'),
          ],
        ),
      ),
    );
  }
}
