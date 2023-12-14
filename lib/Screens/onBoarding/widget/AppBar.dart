
import 'package:flutter/material.dart';
import 'package:sample/Screens/onBoarding/widget/Dilouge_box.dart';
import 'package:sample/Screens/onBoarding/widget/alertForCall.dart';

import '../call_helper/call_helper_controller.dart';

class CurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    int curveHeight = 40;
    Offset controlPoint = Offset(size.width / 2, size.height + curveHeight);
    Offset endPoint = Offset(size.width, size.height - curveHeight);

    Path path = Path()
      ..lineTo(0, size.height - curveHeight)
      ..quadraticBezierTo(
          controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize =>
      const Size.fromHeight(300.0); // Set the preferred height

  @override
  Widget build(BuildContext context) {
    var controller = Call_helper_Controller();
    return ClipPath(
        clipper: CurveClipper(),
        child: AppBar(
          backgroundColor: Colors.green,
          elevation: 0,
          actions: [
            IconButton(
              onPressed: () => {
                //change the language




              },
              icon: const Icon(
                Icons.language_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            //settings
            IconButton(
              onPressed: () => {
                print(controller.helperName),
                print(controller.helperPhoneNumber),
                if (controller.helperName == 'null' ||
                    controller.helperPhoneNumber == 'null')
                  {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => MyDialog(),
                    ),
                  }
                else
                  {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertForCall(
                        name: controller.helperName,
                        number: controller.helperPhoneNumber,
                      ),
                    ),
                  }
              },
              icon: const Icon(
                Icons.call,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
          title: Row(
            children: [
              Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: Image.asset("assets/images/logo.png")),
              const SizedBox(width: 10),
              const Text(
                "EyeC",
                style: TextStyle(
                    decorationStyle: TextDecorationStyle.dotted,
                    color: Colors.white,
                    fontFamily: 'quickens',
                    fontSize: 26),
              ),
            ],
          ),
        ));
  }
}
