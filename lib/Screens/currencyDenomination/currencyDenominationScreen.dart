import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sample/Screens/currencyDenomination/showCurrency.dart';

class currencyDetection extends StatefulWidget {
  final List<CameraDescription> cameras;
  const currencyDetection({required this.cameras, Key? key}) : super(key: key);

  @override
  _currencyDetectionState createState() => _currencyDetectionState();
}

class _currencyDetectionState extends State<currencyDetection> {
  late CameraController _cameraController;
  final FlutterTts flutterTts = FlutterTts();
  bool _isDetecting = false;
  late Future<void> cameraValue;
  String _recognizedObject = 'NO';

  @override
  void initState() {
    super.initState();
    loadModel();
    initCamera();
  }

  @override
  void dispose() {
    Tflite.close();
    _cameraController.stopImageStream();
    _cameraController.dispose();

    super.dispose();
  }

  void initCamera() {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    cameraValue = _cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraController.startImageStream((CameraImage image) {
          if (_isDetecting) return;
          _isDetecting = true;

          runModelOnFrame(image);
        });
      });
    });
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: 'assets/currenctModel.tflite',
      labels: 'assets/currencyLabels.txt',
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  bool isInputBlack = false;
  bool isNotoneInput = false;

  Future runModelOnFrame(CameraImage image) async {
    double averageBrightness = calculateAverageBrightness(image);

    const blackThreshold = 50;

    if (averageBrightness < blackThreshold) {
      if (isInputBlack == false) {
        flutterTts.speak("Input is black, please put camera in front of note.");
        isInputBlack = true;
      }
    }

    try {
      List<dynamic>? recognitionsList = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        asynch: true,
      );

      if (recognitionsList!.length > 1) {
        if (isNotoneInput == false) {
          flutterTts.speak("PLease input only one object");
        } else {
          await Future.delayed(const Duration(seconds: 3));
        }
        isNotoneInput = true;
      }

      // setState(() {
      //   _confidenceLevel = recognitionsList[0]['confidence'];
      //   _recognizedObject = recognitionsList[0]['label'];
      // });

      if (recognitionsList[0]['confidence'] > 0.99) {
        _recognizedObject = recognitionsList[0]['label'];

        _cameraController.stopImageStream();
        flutterTts.stop();

        _cameraController.dispose();

        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => showCurrency(
                    recognizedObject: _recognizedObject,
                  )),
        );
        recognitionsList.clear();
      } else if (recognitionsList[0]['confidence'] < 0.55) {
        _recognizedObject = "others";
        await Future.delayed(const Duration(seconds: 3), () {
          flutterTts.speak("PLease adjust the Note  in front of camera");
        });
      } else if (recognitionsList[0]['confidence'] > 0.55 &&
          recognitionsList[0]['confidence'] < 0.99) {
        _recognizedObject = "Move nearer";
        await Future.delayed(const Duration(seconds: 3), () {
          flutterTts.speak("PLease move the camera more nearer to the Note");
        });
      }
    } catch (e) {
      //   print("Error running detection model: $e");
    } finally {
      _isDetecting = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: WillPopScope(
            onWillPop: () {
              return _onBackPressed();
            },
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text("Currency detection"),
                  backgroundColor: Colors.black,
                ),
                body: Detecting_Camera_Widget())));
    // : GestureDetector(
    //     onDoubleTap: () {
    //       _confidenceLevel = 0.0;
    //       _recognizedObject = "";
    //       _cameraController.startImageStream((CameraImage image) {
    //         if (_isDetecting || _cameraController == null) return;
    //         _isDetecting = true;

    //         runModelOnFrame(image);
    //       });
    //     },
    //     child:
    //         afterDetection(_recognizedObject, _confidenceLevel))),
  }

  // Column afterDetection(String recognizedObject, double confidenceLevel) {
  //   flutterTts.speak("This note is of " + recognizedObject + "rupees");
  //   return Column(
  //     children: [
  //       const SizedBox(height: 100),
  //       const Center(
  //           child: Text(
  //         "DETECTED",
  //         style: TextStyle(
  //             fontSize: 50, color: Colors.red, fontWeight: FontWeight.bold),
  //       )),
  //       const SizedBox(
  //         height: 100,
  //       ),
  //       NoteImages(recognizedObject),
  //       const SizedBox(height: 50),
  //       const SizedBox(height: 30),
  //       Text(
  //         recognizedObject,
  //         style: const TextStyle(
  //             fontSize: 44, color: Colors.green, fontWeight: FontWeight.bold),
  //       ),
  //       Text(confidenceLevel.toString()),
  //     ],
  //   );
  // }

  Column Detecting_Camera_Widget() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
                color: Colors.red,
                height: MediaQuery.of(context).size.height - 100,
                child: CameraPreview(_cameraController)),
            Positioned(
              bottom: 20,
              left: 110,
              child: Text(
                "Detecting....",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        )
      ],
    );
  }

  Future<bool> _onBackPressed() {
    _cameraController.stopImageStream();

    setState(() {});

    Navigator.pushNamed(context, '/onBoarding');
    return Future.value(true);
  }
}

double calculateAverageBrightness(CameraImage image) {
  final plane = image.planes[0];
  final bytes = plane.bytes;
  double totalBrightness = 0;

  for (int i = 0; i < bytes.length; i += plane.bytesPerPixel!) {
    final pixel = bytes[i];
    totalBrightness += pixel;
  }

  final averageBrightness =
      totalBrightness / (bytes.length / plane.bytesPerPixel!);
  return averageBrightness;
}
