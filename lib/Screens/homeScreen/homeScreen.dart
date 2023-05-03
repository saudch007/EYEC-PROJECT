import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  final FlutterTts flutterTts = FlutterTts();
  late AnimationController _controller;
  late Tween<Offset> _tween=Tween<Offset>(
      begin: Offset.zero,
      end: Offset(-0.5, 100),
    );

  @override
  void initState() {
    super.initState();
    _speakInstruction();
     _controller = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: 200),
  );
  
  _controller.repeat(reverse: true);


 
  }


@override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Future<void> _speakInstruction() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.speak(
        "Welcome to the home screen. Swipe left for currency, swipe right for object, and swipe down for obstacle.");
  }

  void _navigateToCurrency() {
    // Navigate to Currency 
  Navigator.pushNamed(context, "/currencyDenomination");
  }

  void _navigateToObject() {
    // Navigate to Object module\
    
  Navigator.pushNamed(context, "/objectRecogination");
  }

  void _navigateToObstacle() {
    // Navigate to Obstacle module
    
  Navigator.pushNamed(context, "/obstacleDetection");
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 70,
        title: Text('Home Screen'),
      ),
      body: GestureDetector(
        onTap: (){
           flutterTts.speak("PLease use double finger to swipe");
        },
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            flutterTts.speak("Starting camera  for Object detection, Please scan the desire object ");
            _navigateToObject();
          } else if (details.delta.dx < 0) {
            flutterTts.speak("Starting camera  for Currency note detection, Please scan the desire note");
            _navigateToCurrency();
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            flutterTts.speak("Starting camera  for obstacle detection, Please scan you path continously");
            _navigateToObstacle();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SlideTransition(
  position: _tween.animate(_controller),
  child: SizedBox(
    height: 90,
    width: 90,
    
        child: Image.asset('assets/images/swipeLeft.png')),
),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Swipe Left for Currency',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
              ),
              SizedBox(height: 50),
                SlideTransition(
                
  position: _tween.animate(_controller),
  child: SizedBox(
    height: 90,
    width: 90,
    
        child: Image.asset('assets/images/swipeRight.png')),
),
              SizedBox(height: 16),
              Center(
                child: Text(
                  'Swipe Right for Object',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24),
                ),
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
