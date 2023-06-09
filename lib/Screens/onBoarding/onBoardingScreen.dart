import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sample/Screens/onBoarding/size_config.dart';

import 'onboarding_contents.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;
  late PageController _controllerSecond;
  FlutterTts flutterTts=new FlutterTts();

  @override
  void initState() {
    _controller = PageController();
    _controllerSecond = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    Color(0xffDAD3C8),
    Color(0xffFFE5DE),
    Color(0xffDCF6E6),
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xFF000000).withOpacity(0.5),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: GestureDetector(
        onTap: ()=>{
    
         _currentPage + 1 == contents.length?   Navigator.pushNamed(context, '/homeScreen'): _controller.nextPage(
                                       duration: const Duration(milliseconds: 200),
                                       curve: Curves.easeIn,
                                     )
        },
        child: Stack(children: [
          PageView.builder(
            physics: const BouncingScrollPhysics(),
            controller: _controllerSecond,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemCount: contents.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.blockV! * 30,
                    ),
                    Image.asset(
                      // Background image
                      'assets/images/logo.png',
                      height: SizeConfig.blockV! * 35,
                    ), //
                  ],
                ),
              );
            },
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
                  controller: _controller,
                  onPageChanged: (value) => setState(() => _currentPage = value),
                  itemCount: contents.length,
                  itemBuilder: (context, i) {
                    flutterTts.speak(contents[i].desc+"PLease double tap to continue");
                    return Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: SizeConfig.blockV! * 5,
                          ),
                          
                          Image.asset(
                            contents[_currentPage].image,
                            height: SizeConfig.blockV! * 30,
                            width: SizeConfig.blockH! * 30,
                          ),
                          Text(
                            contents[i].title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w600,
                              fontSize: (width <= 550) ? 30 : 35,
                            ),
                          ),
                          const SizedBox(height: 15),
                          
                          Text(
                            contents[i].desc,
                            style: TextStyle(
                              fontFamily: "Mulish",
                              fontWeight: FontWeight.w300,
                              fontSize: (width <= 550) ? 17 : 25,
                            ),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              // Expanded(
              //   flex: 1,
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: List.generate(
              //           contents.length,
              //           (int index) => _buildDots(
              //             index: index,
              //           ),
              //         ),
              //       ),
              //       _currentPage + 1 == contents.length
              //           ? Padding(
              //               padding: const EdgeInsets.all(30),
              //               child: ElevatedButton(
              //                 onPressed: () {
              //                   Navigator.pushNamed(context, '/homeScreen');
              //                 },
              //                 child: const Text("START"),
              //                 style: ElevatedButton.styleFrom(
              //                   backgroundColor: Colors.black,
              //                   shape: RoundedRectangleBorder(
              //                     borderRadius: BorderRadius.circular(50),
              //                   ),
              //                   padding: (width <= 550)
              //                       ? const EdgeInsets.symmetric(
              //                           horizontal: 100, vertical: 20)
              //                       : EdgeInsets.symmetric(
              //                           horizontal: width * 0.2, vertical: 25),
              //                   textStyle:
              //                       TextStyle(fontSize: (width <= 550) ? 13 : 17),
              //                 ),
              //               ),
              //             )
              //           : Padding(
              //               padding: const EdgeInsets.all(30),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   TextButton(
              //                     onPressed: () {
              //                       _controller.jumpToPage(2);
              //                     },
              //                     child: const Text(
              //                       "SKIP",
              //                       style: TextStyle(color: Colors.black),
              //                     ),
              //                     style: TextButton.styleFrom(
              //                       elevation: 0,
              //                       textStyle: TextStyle(
              //                         fontWeight: FontWeight.w600,
              //                         fontSize: (width <= 550) ? 13 : 17,
              //                       ),
              //                     ),
              //                   ),
              //                   ElevatedButton(
              //                     onPressed: () {
              //                       _controller.nextPage(
              //                         duration: const Duration(milliseconds: 200),
              //                         curve: Curves.easeIn,
              //                       );
              //                     },
              //                     child: const Text("NEXT"),
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: Colors.black,
              //                       shape: RoundedRectangleBorder(
              //                         borderRadius: BorderRadius.circular(50),
              //                       ),
              //                       elevation: 0,
              //                       padding: (width <= 550)
              //                           ? const EdgeInsets.symmetric(
              //                               horizontal: 30, vertical: 20)
              //                           : const EdgeInsets.symmetric(
              //                               horizontal: 30, vertical: 25),
              //                       textStyle: TextStyle(
              //                           fontSize: (width <= 550) ? 13 : 17),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             )
              //     ],
              //   ),
              // ),
            ],
          ),
        ]),
      ),
    );
  }
}
