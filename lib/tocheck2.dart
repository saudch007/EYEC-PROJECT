import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:sample/Screens/widgets/cameraWidget.dart';
import 'package:sample/bndBox.dart';
import 'package:sample/camera.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

class HomePage extends StatefulWidget {
    final List<CameraDescription> cameras;

  const HomePage({super.key, required this.cameras});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  List recognitionsList=[];
  String denomination='';
  CameraImage? cameraImage;
  String _model="ssd";
  
  List<dynamic>? _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;

  

  // runModel(CameraImage image) async {
  //   try {

  //   var recognitionsList=await Tflite.runModelOnFrame(
  //     bytesList:image.planes.map((plane)
  //      {return plane.bytes;
  //      }).toList(),
      
  //     imageHeight: image.height,
  //     imageWidth: image.width,
  //     imageMean: 0,
  //     imageStd:255,
  //     rotation:90,
  //     numResults: 2,
  //     threshold: 0.1,
  //     asynch: true,
      
    
    
  //   );
  //   setState(() {
     
  //      denomination=recognitionsList![0]['label'];
  //   });
   
  // } catch (e) {
  //   print("Error running detection model: $e");
  // }
  // }

  Future loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt");
  }

  @override
  void dispose() {
    super.dispose();

    Tflite.close();
  }

  @override
  void initState() {
    super.initState();

    loadModel();
  }

  
  setRecognitions(recognitions, imageHeight, imageWidth) {
    if (this.mounted) {
      setState(() {
        _recognitions = recognitions;
        _imageHeight = imageHeight;
        _imageWidth = imageWidth;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Widget> list = [];
    

    list.add(Text(denomination)); 
    list.add(Camera(widget.cameras,'ssd',setRecognitions));  
    list.add(

         BndBox(
              _recognitions ?? [],
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              700,
              100,
              _model),
    );
   

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          margin: EdgeInsets.only(top: 50),
          color: Colors.black,
          child: Stack(
            children: list,
          ),
        ),
      ),
    );
  }
}