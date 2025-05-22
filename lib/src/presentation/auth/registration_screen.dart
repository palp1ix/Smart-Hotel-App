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

  final AuthBloc _authBloc = AuthBloc();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _authBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: _authBloc,
      listener: (context, state) {
        if (state is AuthInProgress) {
          showProgress(context);
        } else {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }

          if (state is AuthFailed) {
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
            if (state.reservation == null) {
              context.router.replaceAll([const CombinedReservationRoute()]);
            } else {
              context.router.replaceAll([HomeRoute()]);
            }
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
                          color:
                              Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.color, // Для адаптации к теме
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
                    HotelPrimaryButton(
                      title: 'Create Account',
                      onPressed:
                          _onRegister, // Вызываем метод, который диспатчит событие
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getGeistText(
                          'Already have account?',
                          color: AppColors.onContainer,
                          weight: 500,
                          size: 14,
                        ),
                        HotelTextButton(
                          onPressed: () {
                            context.router.replace(const LoginRoute());
                          },
                          text: 'Sign In',
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    AuthDivider(),
                    SizedBox(height: 20),
                    HotelPrimaryButton(
                      title: 'Sign In With Google',
                      onPressed: () {
                        // Логика входа через Google (потребует отдельного события и обработки в AuthBloc)
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Google Sign-Up not implemented yet.',
                            ),
                          ),
                        );
                      },
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

  void _onRegister() {
    // Валидация полей
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Please fill in all fields.',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
      return;
    }

    // Отправляем событие Register в AuthBloc
    _authBloc.add(
      Register(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }
}
