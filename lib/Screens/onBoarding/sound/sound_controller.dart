import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:sample/generated/assets.dart';
import 'package:flutter/services.dart';



class SoundsPlay {

  Future<void> playSlide() async {
    AudioPlayer player = AudioPlayer();

    await player.play(AssetSource(Assets.slide));
  }
}
