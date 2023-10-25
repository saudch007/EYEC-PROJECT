import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';

class ShakeToCallService {
  final String phoneNumber;
  late ShakeDetector shakeDetector;

  ShakeToCallService({required this.phoneNumber});

  void startService() {
    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: () {
        _makePhoneCall();
      },
    );
  }

  void stopService() {
    shakeDetector.stopListening();
  }

  void _makePhoneCall() async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }
}
