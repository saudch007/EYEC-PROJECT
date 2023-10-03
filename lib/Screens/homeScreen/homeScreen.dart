import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sample/Screens/homeScreen/selectUsingimage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final FlutterTts flutterTts = FlutterTts();
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<Offset> _animation = Tween<Offset>(
    begin: Offset(-1.0, 0.0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  late final Animation<Offset> _animation_ForRIght = Tween<Offset>(
    begin: Offset.zero,
    end: Offset(-1.0, 0.0),
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  late final Animation<Offset> _animation_ForDown = Tween<Offset>(
    begin: Offset(0.0, -1.0),
    end: Offset.zero,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ),
  );

  @override
  void initState() {
    super.initState();
    _speakInstruction();
    _controller.repeat();
    _startService();
  }

  Future<void> _startService() async {
    try {
      // Launch the app using the BroadcastReceiver
      final AndroidIntent intent = AndroidIntent(
        action: 'com.example.sample.LAUNCH_APP',
        package: 'com.package.sample', // Replace with your app's package name
        componentName:
            'com.package.sample/.MainActivity', // Replace with your app's main activity
      );
      intent.launch();
    } catch (e) {
      print('Error starting service: $e');
    }
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

  void _navigateToObjectRecogination() {
    // flutterTts.speak("This module is currently disabled");
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text("This module is currently disabled")));
    // //   // Navigate to Currency

    Navigator.pushNamed(context, "/objectRecogination");
  }

  void _navigateToCurrency() {
    // // Navigate to Object module\

    Navigator.pushNamed(context, "/currencyDenomination");
  }

  void _navigateToObstacle() {
    // Navigate to Obstacle module
    flutterTts.speak("This module is currently disabled");

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This module is currently disabled")));
    // Navigator.pushNamed(context, "/obstacleDetection");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 70,
        centerTitle: false,
        title: Text('Slide to  the options'),
      ),
      body: GestureDetector(
        onHorizontalDragUpdate: (details) {
          if (details.delta.dx > 0) {
            flutterTts.speak(
                "Starting camera  for Currency note detection, Please scan the desire note");
            _navigateToCurrency();
          } else if (details.delta.dx < 0) {
            flutterTts.speak(
                "Starting camera  for Object detection, Please scan the desire object ");
            _navigateToObjectRecogination();
          }
        },
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 0) {
            flutterTts.speak(
                "Starting camera  for obstacle detection, Please scan you path continously");
            //    _navigateToObstacle();
          }
        },
        child: Column(
          children: [
            Container(
              color: Colors.red,
              height: 220,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: SlideTransition(
                            position: _animation_ForRIght,
                            child: Image.asset(
                              'assets/images/swipeLeft.png',
                              color: Colors.black,
                            )),
                      ),
                      Image.asset("assets/images/object.png",
                          height: 120, width: 120),
                    ],
                  ),
                  Center(
                    child: Text(
                      'Swipe Left for Object',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ],
              ),
            ),

            // SizedBox(height: 50),
            Container(
              color: Colors.yellow,
              height: 220,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        child: SlideTransition(
                            position: _animation,
                            child: Image.asset(
                              'assets/images/swipeRight.png',
                              color: Colors.black,
                            )),
                      ),
                      Image.asset("assets/images/money.png",
                          height: 120, width: 120),
                    ],
                  ),
                  Text(
                    'Swipe Right for Currency',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),

            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SlideTransition(
                        position: _animation_ForDown,
                        child: Icon(
                          Icons.touch_app,
                          size: 100,
                        ),
                      ),
                      Image.asset("assets/images/blind-man.png",
                          height: 120, width: 120),
                    ],
                  ),
                  Text(
                    'Swipe Down for Obstacle',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
            // Row(
            //   children: [
            //     SizedBox(width: 16),
            //     ElevatedButton(
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                   builder: (context) => selectUsingImage()));
            //         },
            //         child: Text("Select image"))
            //   ],
            // )
          ],
        ),
      ),
    );
  }
}
