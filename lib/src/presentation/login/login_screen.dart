import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/hotel_primary_button.dart';
import 'package:smart_hotel_app/core/widgets/hotel_slider.dart';
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
            HotelSlider(iconPath: 'assets/icons/sun.svg'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelTextField(
                controller: controller,
                hintText: 'Email',
                prefixIconPath: AppIcons.atSymbol,
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: HotelTextField(
                controller: controller,
                hintText: 'Password',
                prefixIconPath: AppIcons.key,
              ),
            ),
            SizedBox(height: 20),
            HotelPrimaryButton(title: 'Login', color: AppColors.main),
            HotelTextButton(onPressed: () {}, text: 'Some text'),
          ],
        ),
      ),
    );
  }
}
