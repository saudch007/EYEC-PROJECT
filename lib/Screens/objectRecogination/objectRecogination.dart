import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../widgets/cameraWidget.dart';

class objectRecogination extends StatefulWidget {
  final List<CameraDescription> cameras;
  const objectRecogination({required this.cameras, Key? key}) : super(key: key);

  @override
  State<objectRecogination> createState() => _objectRecoginationState();
}

class _objectRecoginationState extends State<objectRecogination> {
  late CameraController _cameraController;
 bool _isDetecting = false;
  late FlutterTts flutterTts;
  late Future<void> cameraValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize().then((_)  {
if (!mounted) {
        
      }
    setState(() {
       _cameraController.startImageStream((CameraImage image) {
        if (_isDetecting) return;
        _isDetecting = true;
        // TODO: Process the image and detect objects
        bool objectDetected = false; // replace this with the actual object detection logic
        if (objectDetected) {
       
        }
        _isDetecting = false;
      });
    });
    
      
    });


      
    flutterTts = FlutterTts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children:[ cameraWidget(cameraValue: cameraValue, cameraController: _cameraController),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Text(
                  'Detecting...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),))
      ]),
    );
  }
}

