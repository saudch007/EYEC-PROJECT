import 'package:flutter/material.dart';
import 'package:sample/Screens/currencyDenomination/currencyDenominationScreen.dart';
import 'package:sample/Screens/homeScreen/homeScreen.dart';
import 'package:sample/Screens/objectRecogination/objectRecogination.dart';
import 'package:sample/Screens/obstacleDetection/obstacleDetection.dart';
import 'Screens/onBoarding/onBoardingScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OnboardingScreen(),
      routes: {
      
        '/homeScreen': (context) =>  HomeScreen(),
          '/obstacleDetection': (context) =>  obstacleDetection(),
            '/currenctDenomination': (context) =>  currenctDenomination(),
            'objectRecogination':(context) => objectRecogination()
      },
     
    );
  }
}
