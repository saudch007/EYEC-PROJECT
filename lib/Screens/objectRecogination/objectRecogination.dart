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
     final FlutterTts flutterTts = FlutterTts();
  bool _isDetecting = false;
  bool _isDetected=false;
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

      
 
   setState(() {
  
      _confidenceLevel=recognitionsList![0]['confidence'];
      _recognizedObject=recognitionsList[0]['label'];
});


  if(recognitionsList![0]['confidence']>0.99)
      setState(() {
        _recognizedObject = recognitionsList![0]['label'];
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



  
  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
          
          body:  _isDetected==false? Detecting_Camera_Widget():GestureDetector(
            onDoubleTap: (){ },
            
            child: afterDetection(_recognizedObject,_confidenceLevel))
        ),
      ),
    );
  }





  Column afterDetection(String recognizedObject, double confidenceLevel) {
    flutterTts.speak("This note is of "+recognizedObject+"rupees");
    return Column(
  
          children: [
            SizedBox(height: 100),
               Center(child: Text("DETECTED",style: TextStyle(fontSize: 50,color: Colors.red,fontWeight: FontWeight.bold),)),
         SizedBox(height: 100,),
            NoteImages(recognizedObject),
              SizedBox(height: 50),
            SizedBox(height: 30),
            Text(recognizedObject,style: TextStyle(fontSize: 44,color: Colors.black,fontWeight: FontWeight.bold),),
            Text(confidenceLevel.toString()),
            

          ],
        );
  }

  Image NoteImages(String recognizedObject) {
    

    String imagePath;

    // switch (recognizedObject) {
    //   case '10':
    //       imagePath="10b.jpg";
        
    //     break;
    //   default:
    // }
    
    
    return Image(image: AssetImage("assets/images/notes/$recognizedObject"+"b.jpg"));
  }





  Column Detecting_Camera_Widget() {
    return Column(  
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