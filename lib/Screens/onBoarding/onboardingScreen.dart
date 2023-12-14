import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_android_volume_keydown/flutter_android_volume_keydown.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:sample/Screens/onBoarding/onBoarding_contents.dart';
import 'package:sample/Screens/onBoarding/sizeconfig.dart';
import 'package:sample/Screens/onBoarding/sound/sound_controller.dart';
import 'package:sample/Screens/onBoarding/widget/AppBar.dart';
import 'package:sample/Screens/onBoarding/widget/Dilouge_box.dart';
import 'package:sample/Screens/onBoarding/widget/alertForCall.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_watcher/volume_watcher.dart';

import 'call_helper/call_helper_controller.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

const anotherFont = 'quickens';

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final SharedPreferences setLangInLocal;
  late final SharedPreferences setTrans;

  FlutterTts flutterTts = FlutterTts();
  String currentLanguage = "en-US";
  bool englishToUrdu = false;

  String title = "Instructions";
  PageController pageController = PageController(initialPage: 0);
  final Call_helper_Controller controller = Call_helper_Controller();

  late final SharedPreferences _pref;

  StreamSubscription<HardwareButton>? subscription;

  double currentvol = 0.5;
  String buttontype = "none";

  String index = '1';
  String index2 = '2';
  @override
  void initState() {
    super.initState();
    loadLanguages();
    initializeTts();
    Future.delayed(Duration.zero, () async {
      currentvol = await PerfectVolumeControl.getVolume();
      //get current volume

      setState(() {
        //refresh UI
      });
    });
    startListening();
  }

  void timerfor10seconds() {
    Timer(Duration(seconds: 10), () {
      setState(() {
        index = '1';
      });
    });
  }

  void timer2for10seconds() {
    Timer(Duration(seconds: 10), () {
      setState(() {
        index2 = '2';
      });
    });
  }

  void startListening() {
    PerfectVolumeControl.stream.listen((volume) {
      //volume button is pressed,
      // this listener will be triggeret 3 times at one button press

      if (volume != currentvol) {
        //only execute button type check once time
        if (volume < currentvol) {
          //if new volume is greater, then it up button
          buttontype = "up";

          if (controller.helperName == 'null' ||
              controller.helperPhoneNumber == 'null') {
            if (index == '1') {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => MyDialog());
            }
            setState(() {
              index = '0';
            });
          } else {
            if (index == '1') {
              flutterTts.speak("Calling " + controller.helperName);
              controller.callNumber(controller.helperPhoneNumber);
              flutterTts.stop();
              timerfor10seconds();

              setState(() {
                index = '0';
              });
            }
          }
        }
      } else {
        //else it is down button
        if (index2 == '2') {
          setState(() {
            index2 = '0';
          });
          flutterTts.speak("Opening Text Recognizer");
          flutterTts.stop();
          Navigator.pushNamed(context, "/textRecognizer");

          timer2for10seconds();
        }
      }
    });
  }
  //   setState(() {
  //     currentvol = volume;
  //   });
  // });

  void loadLanguages() async {
    setLangInLocal = await SharedPreferences.getInstance();
    setTrans = await SharedPreferences.getInstance();
    currentLanguage = setLangInLocal.getString('getLanguage') ?? 'en-US';
    englishToUrdu = setTrans.getBool('getTrans') ?? false;
  }

  void initializeTts() async {
    await flutterTts.setLanguage(currentLanguage);
    await flutterTts.setSpeechRate(0.6);

    _pref = await SharedPreferences.getInstance();
  }

  void toggleLanguage() {
    if (currentLanguage == "en-US") {
      print("Waleed2");
      changeTtsLanguage("ur-PK"); // Change to Urdu
      englishToUrdu = false;
      setTrans.setBool('getTrans', englishToUrdu);
    } else {
      changeTtsLanguage("en-US"); // Change to English
      englishToUrdu = true;
      setTrans.setBool('getTrans', englishToUrdu);
    }
  }

  void changeTtsLanguage(String newLanguage) async {
    setState(() {
      currentLanguage = newLanguage;
    });
    flutterTts.setLanguage(newLanguage);
  }

  int currentIndex = 0;

  void _navigateToObjectRecogination() {
    Navigator.pushNamed(context, "/objectRecogination");
  }

  void _navigateToCurrency() {
    Navigator.pushNamed(context, "/currencyDenomination");
  }

  void _navigateToSettings() {
    Navigator.pushNamed(context, "/homeScreen");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0), // Set the preferred height
        child: MyAppBar(),
      ),
      body: GestureDetector(
        child: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            ),
          ),
          Center(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: PageView.builder(
                    physics: const BouncingScrollPhysics(),
                    controller: pageController,
                    itemCount: contentsinEgnlist.length,
                    itemBuilder: (context, i) {
                      englishToUrdu
                          ? flutterTts.speak(contentsinEgnlist[i].desc)
                          : flutterTts.speak(contentsInUrdu[i].desc);

                      return GestureDetector(
                        onLongPress: () {
                          print("Waleed");
                          toggleLanguage();
                        },
                        onLongPressCancel: () {
                          print("Waleed");
                        },
                        onDoubleTap: () {
                          if (i == 1) {

                            _navigateToCurrency();
                          } else if (i == 2) {

                            _navigateToObjectRecogination();
                          } else if (i == 3) {
                            flutterTts.speak(
                                "The obstacle detection feature is currently unavailable");
                          } else if (i == 4) {
                            _navigateToSettings();
                          }
                        },
                        // onTap: () => {flutterTts.stop, toggleLanguage()},
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 24, right: 24, top: 40),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // Image.asset(
                                //   contentsinEgnlist[i].image,
                                //   fit: BoxFit.fill,
                                //   height: SizeConfig.blockV! * 20,
                                //   width: SizeConfig.blockH! * 50,
                                // ),
                                i == 0 || i == 2
                                    ? Image.asset(
                                        contentsinEgnlist[i].image,
                                        fit: BoxFit.fill,
                                        height: SizeConfig.blockV! * 20,
                                        width: SizeConfig.blockH! * 50,
                                      )
                                    : Lottie.asset(contentsinEgnlist[i].image,
                                        height: SizeConfig.blockV! * 20,
                                        width: SizeConfig.blockH! * 50,
                                        fit: BoxFit.fill),
                                const SizedBox(height: 10),
                                Text(
                                  englishToUrdu
                                      ? contentsinEgnlist[i].title
                                      : contentsInUrdu[i].title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: anotherFont,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.3,
                                      fontSize: 30,
                                      color: Colors.green.withOpacity(0.8)),
                                ),
                                const SizedBox(height: 100),
                                Text(
                                  englishToUrdu
                                      ? contentsinEgnlist[i].desc
                                      : contentsInUrdu[i].desc,
                                  style: TextStyle(
                                    letterSpacing: 1.4,
                                    color: Colors.black.withOpacity(0.7),
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Mulish',
                                    fontSize: 25,
                                  ),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    onPageChanged: (int page) {
                      setState(() {
                        flutterTts.stop();
                        currentIndex = page;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
