import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class objectRecogination extends StatefulWidget {
  const objectRecogination({super.key});

  @override
  State<objectRecogination> createState() => _objectRecoginationState();
}

class _objectRecoginationState extends State<objectRecogination> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Text("object Recogination"),
    );
  }
}