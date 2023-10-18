import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ObjectRecognition extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ObjectRecognition({required this.cameras, Key? key}) : super(key: key);

  @override
  _ObjectRecognitionState createState() => _ObjectRecognitionState();
}

class _ObjectRecognitionState extends State<ObjectRecognition> {
  late CameraController _cameraController;
  final FlutterTts flutterTts = FlutterTts();
  bool _isDetecting = false;
  bool _isDetected = false;
  late Future<void> cameraValue;
  String _recognizedObject = 'NO';

  double _confidenceLevel = 0.0;

  @override
  void initState() {
    _confidenceLevel = 0.0;
    _recognizedObject = 'NO';

    super.initState();
    loadModel();
    initCamera();
  }

  @override
  void dispose() {
    Tflite.close();
    _cameraController.stopImageStream();
    _cameraController.dispose();

    _isDetecting = false;
    _isDetected = false;
    super.dispose();
  }

  void initCamera() {
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.medium);
    cameraValue = _cameraController!.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _cameraController!.startImageStream((CameraImage image) {
          if (_isDetecting || _cameraController == null) return;
          _isDetecting = true;

          runModelOnFrame(image);
        });
      });
    });
  }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
      model: 'assets/objectModel.tflite',
      labels: 'assets/objectLabels.txt',
    );
  }

  bool isInputBlack = false;
  bool isNotoneInput = false;

  Future runModelOnFrame(CameraImage image) async {
    double averageBrightness = calculateAverageBrightness(image);

    // Define a threshold for black detection
    final blackThreshold = 50;

    if (averageBrightness < blackThreshold) {
      // Input is black, perform your desired action (e.g., speak)
      if (isInputBlack == false) {
        flutterTts.speak("Input is black, please put camera in front of note.");
        isInputBlack = true;
      }
    }

    try {
      wait(53);
      List<dynamic>? recognitionsList = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
      );

      if (recognitionsList!.length > 1) {
        if (isNotoneInput == false) {
          flutterTts.speak("PLease input only one object");
        } else {
          await Future.delayed(const Duration(seconds: 3));
        }
        isNotoneInput = true;
      }

      setState(() {
        _confidenceLevel = recognitionsList[0]['confidence'];
        _recognizedObject = recognitionsList[0]['label'];
      });
      double getConfidence = recognitionsList[0]['confidence'] * 100;

      setState(() {
        _confidenceLevel = getConfidence;
      });

      if (recognitionsList[0]['confidence'] > 0.99) {
        setState(() {
          _recognizedObject = recognitionsList[0]['label'];
          _confidenceLevel = recognitionsList[0]['confidence'];
          _isDetected = true;
          _cameraController.stopImageStream();
        });
      } else if (recognitionsList[0]['confidence'] < 0.55) {
        _isDetected = false;
        await Future.delayed(const Duration(seconds: 3), () {
          _recognizedObject = "Others";
          flutterTts.speak("PLease adjust the object  in front of camera");
        });
      } else if (recognitionsList[0]['confidence'] > 0.55 &&
          recognitionsList[0]['confidence'] < 0.99) {
        _recognizedObject = "Others";
        await Future.delayed(const Duration(seconds: 3), () {
          flutterTts.speak("PLease move the camera more nearer to the object");
        });
      }
    } catch (e) {
      //   print("Error running detection model: $e");
    } finally {
      _isDetecting = false;
    }
  }

  Future<void> wait(int milliseconds) {
    return Future.delayed(Duration(seconds: milliseconds));
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
              backgroundColor: Colors.black,
            ),
            body: _isDetected == false
                ? Detecting_Camera_Widget()
                : GestureDetector(
                    onDoubleTap: () {
                      _confidenceLevel = 0.0;
                      _recognizedObject = "";
                      _cameraController.startImageStream((CameraImage image) {
                        if (_isDetecting || _cameraController == null) return;
                        _isDetecting = true;

                        runModelOnFrame(image);
                      });
                      _isDetected = false;
                      setState(() {});
                    },
                    child:
                        afterDetection(_recognizedObject, _confidenceLevel))),
      ),
    );
  }

  Column afterDetection(String recognizedObject, double confidenceLevel) {
    flutterTts.speak("This object is  " + recognizedObject);
    return Column(
      children: [
        const SizedBox(height: 40),
        const Center(
            child: Text(
          "DETECTED",
          style: TextStyle(
              fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
        )),
        const SizedBox(
          height: 100,
        ),
        const SizedBox(height: 30),
        Text(
          recognizedObject,
          style: TextStyle(
              fontSize: 50, color: Colors.green, fontWeight: FontWeight.bold),
        ),
        Text(confidenceLevel.toString()),
      ],
    );
  }

  Column Detecting_Camera_Widget() {
    return Column(
      children: [
        _isDetected == false
            ? CameraPreview(_cameraController!)
            : Center(child: Text("Detected")),
        Text(
          '$_recognizedObject',
          style: TextStyle(fontSize: 40, color: Colors.green),
        ),
        Text(
          '$_confidenceLevel',
          style: TextStyle(fontSize: 15, color: Colors.green),
        ),
      ],
    );
  }

  Future<bool> _onBackPressed() {
    // your code here
    _cameraController.stopImageStream();
    _isDetected = false;
    setState(() {});
    return Future.value(true);
  }
}

//multiply confidence by 100 to get full in to perecentage.

//if no note detected after 10 seconds the module will be close , you have to double tap to again open that module