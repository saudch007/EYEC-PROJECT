import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

//Haseeb
class _HomeScreenState extends State<HomeScreen> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakInstruction();
  }

  Future<void> _speakInstruction() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(
        "Welcome to the home screen. Swipe left for currency, swipe right for object, and swipe down for obstacle.");
  }

  void _navigateToCurrency() {
    // Navigate to Currency
    Navigator.pushNamed(context, "currencyDenomination");
  }

  void _navigateToObject() {
    // Navigate to Object module\

    Navigator.pushNamed(context, "objectRecogination");
  }

  void _navigateToObstacle() {
    // Navigate to Obstacle module

    Navigator.pushNamed(context, "obstacldeDetection");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: GestureDetector(
        onTap: () {
          flutterTts.speak("PLease use double finger to swipe");
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            flutterTts.speak("Object");
            _navigateToObject();
          } else if (details.delta.dx < 0) {
            flutterTts.speak("Currency");
            _navigateToCurrency();
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            flutterTts.speak("Obstacle");
            _navigateToObstacle();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.arrow_left,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                'Swipe Left for Currency',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 50),
              Icon(
                Icons.arrow_right,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                'Swipe Right for Object',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 50),
              Icon(
                Icons.arrow_downward,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                'Swipe Down for Obstacle',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
