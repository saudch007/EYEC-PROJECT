import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class obstacleDetection extends StatefulWidget {
  const obstacleDetection({super.key});

  @override
  State<obstacleDetection> createState() => _obstacleDetectionState();
}

class _obstacleDetectionState extends State<obstacleDetection> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Text("obstacle DEtection"),
    );
  }
}