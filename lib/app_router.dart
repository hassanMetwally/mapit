import 'package:flutter/material.dart';
import 'business_logic/maps/cubit/maps_cubit.dart';
import 'data/repositories/maps_repository.dart';
import 'data/web_services/maps_web_services.dart';
import 'business_logic/phone_auth/cubit/phone_auth_cubit.dart';
import 'presentation/screens/map_screen.dart';
import 'presentation/screens/otp_screen.dart';
import 'constants/constants.dart';
import 'presentation/screens/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;
  MapsCubit? mapsCubit;
  MapsRepository? mapsRepository;
  MapsWebServices? mapsWebServices;

  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
    mapsWebServices = MapsWebServices();
    mapsRepository = MapsRepository(mapsWebServices: mapsWebServices!);
    mapsCubit = MapsCubit(mapsRepository: mapsRepository!);
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
            child: OtpScreen(
              phoneNumber: phoneNumber,
            ),
          ),
        );

      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<MapsCubit>.value(
            value: mapsCubit!,
            child: const MapScreen(),
          ),
        );
    }
    return null;
  }
}
