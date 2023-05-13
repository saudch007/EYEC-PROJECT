import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/cameraWidget.dart';

class obstacleDetection extends StatefulWidget {

final List<CameraDescription> cameras;
  late Future<void> cameraValue;

   obstacleDetection({ required this.cameras});

  @override
  State<obstacleDetection> createState() => _obstacleDetectionState();
}

class _obstacleDetectionState extends State<obstacleDetection> {
  late CameraController _cameraController;

  late Future<void> cameraValue;


    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.ultraHigh);
    cameraValue = _cameraController.initialize();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: cameraWidget(cameraValue: cameraValue, cameraController: _cameraController),
    );
  }
}