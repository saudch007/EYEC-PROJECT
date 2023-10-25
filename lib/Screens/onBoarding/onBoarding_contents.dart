import 'package:flutter_tts/flutter_tts.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;
  FlutterTts flutterTts = FlutterTts();

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contentsinEgnlist = [
  OnboardingContents(
    title: "Instructions",
    image: "assets/images/blind-man.png",
    desc:
        "This application is build for Blind people to help them in their daily life.Please slide left ",
  ),
  OnboardingContents(
    title: "Detect currency denomination",
    image: "assets/images/money.png",
    desc:
        "You can detect denomination on an Pakistani currency note  Please Double tap to open and slide left to move next ",
  ),
  OnboardingContents(
    title: "Detect food items",
    image: "assets/images/object.png",
    desc:
        "You can detect food items by using phone camera,Please Double tap to open and slide left to move next",
  ),
  OnboardingContents(
    title: "Obstacle Detection",
    image: "assets/images/blind-man.png",
    desc:
        "The system will guide you to avoid obstacles in your path,Please Double tap to open and slide left to move next",
  ),
];

List<OnboardingContents> contentsInUrdu = [
  OnboardingContents(
    title: "Instructions",
    image: "assets/images/image3.png",
    desc:
        "یہ ایپلیکیشن نابینا افراد کے لیے بنائی گئی ہے تاکہ ان کی روزمرہ کی زندگی میں مدد کی جا سکے۔ براہ کرم بائیں طرف سلائیڈ کریں",
  ),
  OnboardingContents(
    title: "Detect currency denomination",
    image: "assets/images/image1.png",
    desc:
        "آپ پاکستانی کرنسی نوٹ پر فرق کا پتہ لگا سکتے ہیں، براہ کرم کھولنے کے لیے دو بار تھپتھپائیں اور اگلا جانے کے لیے بائیں طرف سلائیڈ کریں۔ ",
  ),
  OnboardingContents(
    title: "Detect object in your radius",
    image: "assets/images/image2.png",
    desc:
        "پ فون کیمرہ استعمال کرکے اشیاء کا پتہ لگاسکتے ہیں، براہ کرم کھولنے کے لیے دو بار تھپتھپائیں اور آگے جانے کے لیے بائیں طرف سلائیڈ کریں",
  ),
  OnboardingContents(
    title: "Obstacle Detection",
    image: "assets/images/image3.png",
    desc:
        "سسٹم آپ کے راستے میں رکاوٹوں سے بچنے کے لیے آپ کی رہنمائی کرے گا، براہ کرم کھولنے کے لیے دو بار تھپتھپائیں اور اگلا جانے کے لیے بائیں طرف سلائیڈ کریں",
  ),
  OnboardingContents(
    title: "Instructions",
    image: "assets/images/image3.png",
    desc: "میں اردو میں بات کر رہا ہوں",
  ),
];
