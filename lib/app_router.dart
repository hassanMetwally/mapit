import 'package:flutter/material.dart';
import 'package:mapit/business_logic/phone_auth/cubit/phone_auth_cubit.dart';
import 'package:mapit/presentation/screens/map_screen.dart';
import 'package:mapit/presentation/screens/otp_screen.dart';
import 'constants/constants.dart';
import 'presentation/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;

  AppRouter(){
    phoneAuthCubit = PhoneAuthCubit();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: LoginScreen(),
          ),
        );

      case otpScreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<PhoneAuthCubit>.value(
            value: phoneAuthCubit!,
            child: OtpScreen(phoneNumber: phoneNumber,),
          ),
        );

      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => MapScreen(),
        );
    }
    return null;
  }
}
