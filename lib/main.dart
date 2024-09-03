import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_router.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyCcX4a7H4ptJz4-0f--q0D7cmqyS_XRbtw',
      appId: '1:543007591072:android:064bd202b322072c3b97c5',
      messagingSenderId: '543007591072',
      projectId: 'mapit-79751',
      storageBucket: 'mapit-79751.appspot.com',
    ),
  );

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      initialRoute = loginScreen;
    } else {
      initialRoute = mapScreen;
    }
  });

  runApp(
    MyApp(
      appRouter: AppRouter(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: appRouter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
