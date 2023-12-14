import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sample/Screens/onBoarding/call_helper/call_helper_controller.dart';

class AlertForCall extends StatefulWidget {
  final String name;
  final String number;

  const AlertForCall({super.key, required this.name, required this.number});
  @override
  _AlertForCallState createState() => _AlertForCallState(

  );
}

class _AlertForCallState extends State<AlertForCall> {
  FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {

    final Call_helper_Controller controller = Call_helper_Controller();

    return AlertDialog(
      title: Text('Call '+widget.name),

      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.green, // background
            onPrimary: Colors.white, // foreground
          ),
          onPressed: () {

            controller.callNumber(controller.helperPhoneNumber);
            // Close the dialog without doing anything

            Navigator.pop(context);
            //Navigator.pushNamed(context, "/onboarding");
          },
          child: Text('Call'),
        ),
        ElevatedButton(
          onPressed: () {
            // Close the dialog without doing anything

            Navigator.pushNamed(context, "/onboarding");
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          //change color
          style: ElevatedButton.styleFrom(
            primary: Colors.red, // background
            onPrimary: Colors.white, // foreground
          ),

          onPressed: () {
            controller.deleteFromSharedPref();
            // Close the dialog without doing anything

            Navigator.pushNamed(context, "/onboarding");
          },
          child: Text('Delete Helper'),
        ),
      ],
    );
  }
}
