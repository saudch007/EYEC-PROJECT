import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class MyAppFlaw extends StatefulWidget {
  final List<CameraDescription> cameras;

  const MyAppFlaw({super.key, required this.cameras});

  @override
  State<MyAppFlaw> createState() => _MyAppFlawState();
}

String s = "";

class _MyAppFlawState extends State<MyAppFlaw> {
  final ImagePicker picker = ImagePicker();
  late CameraController _cameraController;

  late Future<void> _initializeControllerFuture;

  File? _capturedImage;
  Future<void> _initializeCamera() async {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);

    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();
    FlutterTts flutterTts = FlutterTts();
    flutterTts.speak("Please  tap to detect price");

    flutterTts.speak("Please double tap to go back");
    _initializeCamera();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed
    _cameraController.dispose();
    super.dispose();
  }

  //on back
  void _onBackPressed() {
    Navigator.pop(context);
  }

  void _timer() async {
    await Future.delayed(Duration(seconds: 10));
    print("Waleed");
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: GestureDetector(
          onDoubleTap: () {
            _onBackPressed();
          },
          onTap: () async {
            await onTapScreen();
          },
          child: Scaffold(
            backgroundColor: Colors.white60,
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: _capturedImage != null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Text(
                                s,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20),
                              ),
                              Image.file(_capturedImage!)
                            ])
                      : FutureBuilder<void>(
                          future: _initializeControllerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return CameraPreview(_cameraController);
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                ),
                Positioned(
                  bottom: 20,
                  child: GestureDetector(
                    onTap: () async {
                      await onTapScreen();
                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Center(
                        child: const Icon(
                          Icons.camera_alt,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapScreen() async {
    final XFile? image = await _captureImage();
    if (image != null) {
      _capturedImage = File(image.path);
      setState(() {
        _capturedImage = File(image.path);
      });
      _timer();
      String a = await getImageTotext(image.path);
      String price = extractPrice(a);
      FlutterTts flutterTts = FlutterTts();
      flutterTts.speak("The price is $price");
      setState(() {
        s = price;
      });
    }
  }

  Future<XFile?> _captureImage() async {
    try {
      await _initializeControllerFuture;
      XFile image = await _cameraController.takePicture();
      return image;
    } catch (e) {
      print("Error capturing image: $e");
      return null;
    }
  }
}

Future<String> getImageTotext(final imagePath) async {
  final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
  final RecognizedText recognizedText =
      await textRecognizer.processImage(InputImage.fromFilePath(imagePath));
  String text = recognizedText.text.toString();
  return text;
}

String extractPrice(String text) {
  String price = "";
  text = text.replaceAll(" ", "");
  //remove all the lines
  text = text.replaceAll("\n", "");
   print(text);


  //remove all the space from the text

  for (int i = 0; i < text.length; i++) {
    if ((text[i] == "R" && text[i + 1] == "s") ||
        (text[i] == "r" && text[i + 1] == "s") ||
        (text[i] == "R" && text[i + 1] == "S")) {
      print(text[i]);
      print(text[i + 1]);
      for (int j = i + 2; j < text.length; j++) {
        //if text[j] not equal to numeric
        if (!isDigit(text[j])) {
          break;
        } else {
          price = price + text[j];
        }
      }

      price += "rupees";
      break;
    }
    if ((text[i] == "R" || text[i] == "r") &&
        text[i + 1] == "u" &&
        text[i + 2] == "p" &&
        text[i + 3] == "e" &&
        text[i + 4] == "e" &&
        text[i + 5] == "s") {
      for (int j = i + 6; j < text.length; j++) {
        //if text[j] not equal to numeric
        if (!isDigit(text[j])) {
          break;
        } else {
          price = price + text[j];
        }
      }
      price += "rupees";
      //break the outer loop
      break;
    }

    if (text[i] == '\$') {
      print(text[i + 1]);
      for (int j = i + 1; j < text.length; j++) {
        //if text[j] not equal to numeric
        if (!isDigit(text[j])) {
          break;
        } else {
          price = price + text[j];
        }
      }
      price += " dollars";
      break;
    }
  }
  return price;
}

bool isDigit(String text) {
  if (text == "0" ||
      text == "1" ||
      text == "2" ||
      text == "3" ||
      text == "4" ||
      text == "5" ||
      text == "6" ||
      text == "7" ||
      text == "8" ||
      text == "9" ||
      text == "." ||
      text == ",") {
    return true;
  } else {
    return false;
  }
}
