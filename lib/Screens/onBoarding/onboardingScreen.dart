import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sample/Screens/onBoarding/onBoarding_contents.dart';
import 'package:sample/Screens/onBoarding/sizeconfig.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  PageController pageController = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    loadLanguages();
    initializeTts();
  }

  void loadLanguages() async {
    setLangInLocal = await SharedPreferences.getInstance();
    setTrans = await SharedPreferences.getInstance();
    currentLanguage = setLangInLocal.getString('getLanguage') ?? 'en-US';
    englishToUrdu = setTrans.getBool('getTrans') ?? false;
  }

  void initializeTts() async {
    await flutterTts.setLanguage(currentLanguage);
    await flutterTts.setSpeechRate(0.6);
  }

  void toggleLanguage() {
    if (currentLanguage == "en-US") {
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

  List colors = const [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffDCF6E6),
  ];

  void _navigateToObjectRecogination() {
    Navigator.pushNamed(context, "/objectRecogination");
  }

  void _navigateToOstacleDetection() {
    flutterTts.speak("This module is currently disabled");
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("This module is currently disabled")));
    // //   // Navigate to Currency

    Navigator.pushNamed(context, "/objectRecogination");
  }

  void _navigateToCurrency() {
    // // Navigate to Object module\

    Navigator.pushNamed(context, "/currencyDenomination");
  }

  void _navigateToSettings() {
    // // Navigate to Object module\

    Navigator.pushNamed(context, "/homeScreen");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 90,
        title: const Text(
          "EyeC",
          style: TextStyle(
              color: Colors.white, fontFamily: 'quickens', fontSize: 26),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.settings, size: 30, color: Colors.white),
          ),
        ],
      ),
      body: GestureDetector(
        // onTap: () => {
        //   _currentPage + 1 == contents.length
        //       ? Navigator.pushNamed(context, '/homeScreen')
        //       : _controller.nextPage(
        //           duration: const Duration(milliseconds: 200),
        //           curve: Curves.easeIn,
        //         )
        // },

        child: Stack(children: [
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              // Background image
              'assets/images/logo.png',
              height: 10 * 20,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black.withOpacity(0.5),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 3,
                child: PageView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: pageController,
                  itemCount: contentsinEgnlist.length,
                  itemBuilder: (context, i) {
                    flutterTts.speak(englishToUrdu == true
                        ? contentsinEgnlist[i].desc
                        : contentsInUrdu[i].desc);

                    return GestureDetector(
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
                      onTap: () => {flutterTts.stop, toggleLanguage()},
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 24, right: 24, top: 40),
                        child: Column(
                          children: [
                            Image.asset(
                              englishToUrdu == true
                                  ? contentsinEgnlist[i].image
                                  : contentsInUrdu[i].image,
                              fit: BoxFit.fill,
                              height: SizeConfig.blockV! * 20,
                              width: SizeConfig.blockH! * 50,
                            ),
                            Text(
                              englishToUrdu == true
                                  ? contentsinEgnlist[i].title
                                  : contentsInUrdu[i].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: anotherFont,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.3,
                                  fontSize: 30,
                                  color: Colors.white.withOpacity(0.8)),
                            ),
                            const SizedBox(height: 40),
                            Text(
                              englishToUrdu == true
                                  ? contentsinEgnlist[i].desc
                                  : contentsInUrdu[i].desc,
                              style: TextStyle(
                                letterSpacing: 1.4,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Mulish',
                                fontSize: 25,
                              ),
                              textAlign: TextAlign.center,
                            )
                          ],
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
        ]),
      ),
    );
  }
}
