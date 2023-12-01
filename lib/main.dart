import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/Screens/currencyDenomination/currencyDenominations.dart';

import 'package:sample/Screens/objectRecogination/objectRecogination.dart';
import 'package:sample/Screens/onBoarding/onboardingScreen.dart';
import 'package:sample/Screens/settings/settings.dart';
import 'package:sample/Screens/splashScreen/splashScreen.dart';
import 'services/callService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  final shakeService = ShakeToCallService(phoneNumber: '+923167566055');
  shakeService.startService(); // Start the shake detection service

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final MethodChannel platform =
      MethodChannel('your.package.name/volume_button');

  MyApp({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        //  '/obstacleDetection':
        '/currencyDenomination': (context) =>
            CurrencyDenomination(cameras: cameras),
        '/objectRecogination': (context) => ObjectRecognition(cameras: cameras),
        '/settings': (context) => const Settings(),
      },
    );
  }
}
