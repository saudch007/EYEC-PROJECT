import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flutterTts.speak("Settings open");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    flutterTts.speak("Settings Close");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: 90,
        title: const Text(
          "EyeC",
          style: TextStyle(
              color: Colors.white, fontFamily: 'quickens', fontSize: 26),
        ),
      ),
      body: Container(),
    );
  }
}
