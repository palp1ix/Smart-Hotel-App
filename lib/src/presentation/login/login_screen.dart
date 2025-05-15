import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/hotel_button_container.dart';
import 'package:smart_hotel_app/core/widgets/hotel_circle_selector.dart';
import 'package:smart_hotel_app/core/widgets/hotel_icon_switch.dart';
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                HotelCircleSelector(),
                HotelButtonContainer(
                  width: 114,
                  height: 81,
                  iconPath: 'assets/icons/heart.svg',
                  text: 'Romantic',
                ),
                HotelIconSwitch(
                  onSelect: () {
                    print('Hui, chlen');
                  },
                  onUnSelect: () {},
                  iconPath: 'assets/icons/power.svg',
                ),
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
        ),
      ),
    );
  }
}
