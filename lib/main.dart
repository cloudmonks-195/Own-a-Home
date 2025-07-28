import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smarthome_app_ui/constants.dart';
import 'package:smarthome_app_ui/firebase_options.dart';
import 'package:flutter/gestures.dart';
import 'package:smarthome_app_ui/pages/splash_screen.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: <PointerDeviceKind>{
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
        },
      ),
      title: 'Smart Home App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: themeColor,
        ),
        fontFamily: "Ubuntu",
        useMaterial3: true,
        iconTheme: const IconThemeData(color: white),
      ),
      home: const SplashScreen(),
    );
  }
}
