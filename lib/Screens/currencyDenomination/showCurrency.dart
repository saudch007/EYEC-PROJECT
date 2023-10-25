// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';

// class showCurrency extends StatefulWidget {
//   final String recognizedObject;
//   const showCurrency({super.key, required this.recognizedObject});

//   @override
//   State<showCurrency> createState() => _showCurrencyState();
// }

// class _showCurrencyState extends State<showCurrency> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     _speakCurrency(widget.recognizedObject, context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: GestureDetector(
//       onHorizontalDragUpdate: (details) {
//         if (details.delta.dx > 0) {
//           Navigator.pushNamed(context, '/currencyDenomination');
//           print("Waleed");
//         } else if (details.delta.dx < 0) {
//           Navigator.pushNamed(context, '/onboarding');
//           print("Ahnmed");
//         }
//       },
//       child: Container(
//         color: Colors.black,
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           children: [
//             const SizedBox(height: 100),
//             const Center(
//                 child: Text(
//               "DETECTED",
//               style: TextStyle(
//                   fontSize: 50, color: Colors.red, fontWeight: FontWeight.bold),
//             )),
//             const SizedBox(
//               height: 100,
//             ),
//             noteImages(widget.recognizedObject),
//             const SizedBox(height: 50),
//             const SizedBox(height: 30),
//             Text(
//               widget.recognizedObject + " \nPakistani Rupees",
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                   fontSize: 44,
//                   color: Colors.green,
//                   fontWeight: FontWeight.bold),
//             ),
//             // Text(confidenceLevel.toString()),
//           ],
//         ),
//       ),
//     ));
//   }
// }

// void _speakCurrency(String note, BuildContext context) {
//   FlutterTts flutterTts = FlutterTts();
//   flutterTts.speak("Note Detected");
//   flutterTts.speak("This note is of " + note + "rupees");

//   Future.delayed(const Duration(seconds: 3), () {
//     flutterTts.speak(
//         "Slide left to go Home screen and Slide Right to again detect note");
//   });
// }

// Image noteImages(String recognizedObject) {
//   return Image(
//       image: AssetImage("assets/images/notes/${recognizedObject}b.jpg"));
// }
