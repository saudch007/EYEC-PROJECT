import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class currenctDenomination extends StatefulWidget {
  const currenctDenomination({super.key});

  @override
  State<currenctDenomination> createState() => _currenctDenominationState();
}

class _currenctDenominationState extends State<currenctDenomination> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      child: Text("currencyDenomination"),
    );
  }
}