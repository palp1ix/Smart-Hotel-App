import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_hotel_app/core/colors/colors.dart';
import 'package:smart_hotel_app/core/fonts/fonts.dart';
import 'package:smart_hotel_app/core/icons/icons.dart';
import 'package:smart_hotel_app/core/widgets/auth_divider.dart';
import 'package:smart_hotel_app/core/widgets/show_progress.dart';
import 'package:smart_hotel_app/core/widgets/widgets.dart';
import 'package:smart_hotel_app/router/router.gr.dart';
import 'package:smart_hotel_app/src/bloc/auth_bloc/auth_bloc.dart';

@RoutePage()
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthBloc _authBloc = AuthBloc();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthInProgress) {
          showProgress(context);
        } else if (state is AuthFailed) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                state.message,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          );
        } else if (state is AuthSuccess) {
          Navigator.of(context).pop();
          if (state.reservation == null) {
            context.router.replaceAll([const CombinedReservationRoute()]);
          } else {
            context.router.replaceAll([HomeRoute()]);
          }
        }
      },
      child: GestureDetector(
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
                    HotelPrimaryButton(title: 'Login', onPressed: _onLogin),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getGeistText(
                          'Don\'t have an account?',
                          color: AppColors.onContainer,
                          weight: 500,
                          size: 14,
                        ),
                        HotelTextButton(
                          onPressed: () {
                            context.router.replace(RegistrationRoute());
                          },
                          text: 'Create an account',
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
      ),
    );
  }

  void _onLogin() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Check your email and password',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
      return;
    }
    _authBloc.add(
      Login(email: _emailController.text, password: _passwordController.text),
    );
  }
}
