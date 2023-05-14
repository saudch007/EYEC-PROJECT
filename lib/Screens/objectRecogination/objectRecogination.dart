import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:tflite/tflite.dart';

class ObjectRecognition extends StatefulWidget {
  final List<CameraDescription> cameras;

  const ObjectRecognition({required this.cameras, Key? key}) : super(key: key);

  @override
  _ObjectRecognitionState createState() => _ObjectRecognitionState();
}

class _ObjectRecognitionState extends State<ObjectRecognition> {
   CameraController? _cameraController;
  bool _isDetecting = false;
  bool _isDetected=false;
  late FlutterTts flutterTts;
  late Future<void> cameraValue;
  String _recognizedObject = 'NO';
  
  double _confidenceLevel=0.0;
   bool _timerActive = false;
  Timer? _timer;

  @override
  void initState() {
    _confidenceLevel=0.0;
    _recognizedObject='NO';
    _cameraController=null;

    super.initState();
    loadModel();
    initCamera();
    flutterTts = FlutterTts();
  }

  @override
  void dispose() {
    Tflite.close();
      _cameraController!.stopImageStream();
      _cameraController!.dispose();
    
    _isDetecting = false;
    _isDetected=false;
    super.dispose();
  }

  void initCamera() {
    _cameraController = CameraController(widget.cameras[0], ResolutionPreset.medium);
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
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future runModelOnFrame(CameraImage image) async {
    try {
      List<dynamic>? recognitionsList = await Tflite.runModelOnFrame(
        bytesList: image.planes.map((plane) => plane.bytes).toList(),
        imageHeight: image.height,
        imageWidth: image.width,
        imageMean: 0,
        imageStd: 255,
        rotation: 90,
        numResults: 1,
        threshold: 0.1,
        asynch: true,
      );

      
  if (recognitionsList != null && recognitionsList.isNotEmpty) {
    Map<String, dynamic> map = recognitionsList[0];
    if (map.containsKey("scores") && map.containsKey("labels")) {
      List<dynamic>? scores = map["scores"];
      List<dynamic>? labels = map["labels"];

      if (scores != null && labels != null && scores.isNotEmpty && labels.isNotEmpty) {
        // Get the label and score with the highest probability
        int index = 0;
        double maxScore = scores[0];
        for (int i = 1; i < scores.length; i++) {
          if (scores[i] > maxScore) {
            index = i;
            maxScore = scores[i];
          }
        }
        String label = labels[index];
        double confidence = maxScore;

        // Do something with the label and confidence
        print("Label: $label");
        print("Confidence: $confidence");
        setState(() {
  
      _confidenceLevel=confidence;
      _recognizedObject=label;
});
      }
    }
  }


  if(recognitionsList![0]['confidence']>=1)
      setState(() {
        _recognizedObject = recognitionsList![0]['label'][0];
        _confidenceLevel=recognitionsList[0]['confidence'];
        _isDetected=true;
        _cameraController!.stopImageStream();
        
      });
    } catch (e) {
      print("Error running detection model: $e");
    } finally {
      _isDetecting = false;
    }
  }



  
  void _startTimer() {
    _timerActive = true;
    _timer = Timer(Duration(seconds: 10), () {
      setState(() {
        _timerActive = false;
        _cameraController!.stopImageStream();
      });
    });
  }

  void _restartCamera() {
    if (_timerActive) {
      return;
    }
    setState(() {
      _cameraController!.startImageStream((CameraImage image) {
        if (!_isDetecting && !_timerActive) {
          _isDetecting = true;
          runModelOnFrame(image);
          _startTimer();
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: () => _restartCamera(),
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          
          body: Column(  
            children: [
             _isDetected==false? CameraPreview(_cameraController!):Center(child: Text("Detected")),
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  children: [
                    Text('$_recognizedObject',style: 
                    TextStyle(fontSize: 40),),
                    Text(
                      '$_confidenceLevel',
                      style: TextStyle(fontSize: 30, color: Color.fromARGB(255, 18, 0, 0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   Future<bool> _onBackPressed() {
    // your code here
    _cameraController!.stopImageStream();
    _isDetected=false;
    setState(() {
      
    });
        return Future.value(true);
  }
}

//multiply confidence by 100 to get full in to perecentage.

//if no note detected after 10 seconds the module will be close , you have to double tap to again open that module