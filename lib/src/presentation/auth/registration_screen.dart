import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/auth_divider.dart';
import 'package:smart_hotel_app/core/widgets/widgets.dart';

@RoutePage()
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          surfaceTintColor: AppColors.background,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Sign',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: 'Up',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                            color: AppColors.main,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                  HotelTextField(
                    controller: _firstNameController,
                    hintText: 'First Name',
                  ),
                  const SizedBox(height: 10),

                  HotelTextField(
                    controller: _lastNameController,
                    hintText: 'Last Name',
                  ),
                  const SizedBox(height: 30),

                  HotelTextField(
                    controller: _emailController,
                    hintText: 'Email',
                    prefixIconPath: AppIcons.atSymbol,
                  ),
                  const SizedBox(height: 10),
                  HotelTextField(
                    controller: _passwordController,
                    hintText: 'Password',
                    prefixIconPath: AppIcons.key,
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  HotelPrimaryButton(title: 'Create Account', onPressed: () {}),
                  SizedBox(height: 60),
                  AuthDivider(),
                  SizedBox(height: 20),
                  HotelPrimaryButton(
                    title: 'Sign In With Google',
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      AppIcons.google,
                      width: 26,
                      height: 26,
                    ),
                    color: AppColors.container,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
