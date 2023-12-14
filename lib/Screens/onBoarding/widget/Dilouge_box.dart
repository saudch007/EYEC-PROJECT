import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sample/Screens/onBoarding/call_helper/call_helper_controller.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    final Call_helper_Controller controller = Call_helper_Controller();
    return AlertDialog(
      title: Text('Helper Information'),
      content: Container(
        height: 250,
        width: 400,
        child: Column(
          children: [
            TextField(
              controller: controller.name_controller,
              decoration: InputDecoration(labelText: 'Helper Name'),
            ),
            TextField(
              controller: controller.phone_numberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Do something with the text field values
            String name = controller.name_controller.text;
            String phone_number = controller.phone_numberController.text;

            flutterTts.speak('Your helper name is $name and his phone number is $phone_number');
            controller.saveInHive(name, phone_number);
            Navigator.pushNamed(context, "/onboarding");
          },
          child: Text('OK'),
        ),
        ElevatedButton(
          onPressed: () {
            // Close the dialog without doing anything

            Navigator.pushNamed(context, "/onboarding");
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
