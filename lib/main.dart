import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sample/Screens/currencyDenomination/currencyDenominationScreen.dart';
import 'package:sample/Screens/homeScreen/homeScreen.dart';
import 'package:sample/Screens/objectRecogination/objectRecogination.dart';
import 'package:sample/Screens/obstacleDetection/obstacleDetection.dart';
import 'package:sample/Screens/splashScreen/splashScreen.dart';
import 'package:sample/toCheck.dart';
import 'package:sample/tocheck2.dart';
import 'Screens/onBoarding/onBoardingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
      routes: {
        '/homeScreen': (context) => HomeScreen(),
        '/obstacleDetection': (context) => obstacleDetection(cameras: cameras),
        '/currencyDenomination': (context) => currenctDenomination(cameras: cameras),
        '/objectRecogination': (context) => ObjectRecognition(cameras: cameras)
      },
    );
  }
}