import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/auth_divider.dart';
import 'package:smart_hotel_app/core/widgets/widgets.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                          text: 'In',
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
                  Align(
                    alignment: Alignment.centerRight,
                    child: HotelTextButton(
                      onPressed: () {},
                      text: 'Forgot password',
                    ),
                  ),
                  const SizedBox(height: 20),
                  HotelPrimaryButton(title: 'Login', onPressed: () {}),
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
