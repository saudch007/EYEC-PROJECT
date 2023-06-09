import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../widgets/cameraWidget.dart';

class currenctDenomination extends StatefulWidget {
   final List<CameraDescription> cameras;
 
  const currenctDenomination({ required this.cameras});
  

  @override
  State<currenctDenomination> createState() => _currenctDenominationState();
}

class _currenctDenominationState extends State<currenctDenomination> {

   late CameraController _cameraController;

  late Future<void> cameraValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cameraController =
        CameraController(widget.cameras[0], ResolutionPreset.high);
    cameraValue = _cameraController.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: cameraWidget(cameraValue: cameraValue, cameraController: _cameraController)
    );
  }
}