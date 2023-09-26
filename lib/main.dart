import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sample/Screens/currencyDenomination/currencyDenominationScreen.dart';
import 'package:sample/Screens/homeScreen/homeScreen.dart';
import 'package:sample/Screens/objectRecogination/objectRecogination.dart';
import 'package:sample/Screens/obstacleDetection/obstacleDetection.dart';
import 'package:sample/Screens/splashScreen/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  final MethodChannel platform =
      MethodChannel('your.package.name/volume_button');

  MyApp({required this.cameras, Key? key}) : super(key: key);
  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    platform.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onVolumeDownPressed') {
        // Volume down button was pressed, start your app
        // Implement your logic here
      }
    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreenPage(),
      routes: {
        '/homeScreen': (context) => HomeScreen(),
        '/obstacleDetection': (context) => obstacleDetection(cameras: cameras),
        '/currencyDenomination': (context) =>
            currencyDetection(cameras: cameras),
        '/objectRecogination': (context) => ObjectRecognition(cameras: cameras),
      },
    );
  }
}
