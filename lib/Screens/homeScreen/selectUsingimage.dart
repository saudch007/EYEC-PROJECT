// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:sample/sources/tflite.dart';

// class selectUsingImage extends StatefulWidget {
//   @override
//   _selectUsingImageState createState() => _selectUsingImageState();
// }

// class _selectUsingImageState extends State<selectUsingImage> {
//   final FlutterTts flutterTts = FlutterTts();
//   bool _isDetected = false;
//   String _recognizedObject = 'NO';
//   double _confidenceLevel = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   Future loadModel() async {
//     Tflite.close();
//     await Tflite.loadModel(
//       model: 'assets/objectModel.tflite',
//       labels: 'assets/objectLabels.txt',
//       isAsset: true,
//       useGpuDelegate: false,
//     );
//   }

//   List<dynamic> inferenceResults = [];
//   Future<void> pickAndProcessImage() async {
//     final imagePicker = ImagePicker();
//     final pickedFile = await imagePicker.getImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       String imagePath = pickedFile.path;

//       // Run inference on the selected image
//       List<dynamic>? output = await Tflite.runModelOnImage(
//         path: imagePath,
//         numResults: 1, // Number of results you want to get
//       );

//       // Process the output (e.g., display results in your UI)
//       // output contains information about the inference results
//       setState(() {
//         inferenceResults = output!;
//         _isDetected = true;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         title: Text("Currency Detection"),
//         backgroundColor: Colors.black,
//       ),
//       body: _isDetected ? _buildResultWidget() : _buildImagePickerWidget(),
//     );
//   }

//   Widget _buildImagePickerWidget() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ElevatedButton(
//             onPressed: pickAndProcessImage,
//             child: Text("Select Image"),
//           ),
//           // Text(
//           //   inferenceResults[0]['label'] ?? 'NO',
//           //   style: TextStyle(fontSize: 40),
//           // ),
//           Text(
//             '$_confidenceLevel',
//             style:
//                 TextStyle(fontSize: 30, color: Color.fromARGB(255, 18, 0, 0)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResultWidget() {
//     flutterTts.speak("The detected fooditem is  " + _recognizedObject);

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           "DETECTED",
//           style: TextStyle(
//               fontSize: 50, color: Colors.red, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 100),
//         //  NoteImages(_recognizedObject),
//         SizedBox(height: 50),
//         Text(
//           inferenceResults[0]['label'] ?? 'NO',
//           style: TextStyle(
//               fontSize: 44, color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         Text(_confidenceLevel.toString()),
//       ],
//     );
//   }

//   Image NoteImages(String recognizedObject) {
//     String imagePath;

//     switch (recognizedObject) {
//       case '10':
//         imagePath = "10b.jpg";
//         break;
//       default:
//     }

//     return Image(
//         image: AssetImage("assets/images/notes/$recognizedObject" + "b.jpg"));
//   }
// }
