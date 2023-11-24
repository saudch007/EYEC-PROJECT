// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:sample/Screens/objectRecogination/objectRecogination.dart';

// void main() {
//   testWidgets('Object Recognition - Initial UI', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(
//       home: ObjectRecognition(
//         cameras: [],
//       ),
//     ));

//     // Verify that the initial UI is displayed correctly.
//     expect(find.text('DETECTED'), findsNothing);
//     expect(find.byType(CameraPreview), findsOneWidget);
//     expect(find.text('NO'), findsOneWidget);
//     expect(find.text('0.0'), findsOneWidget);
//   });

//   testWidgets('Object Recognition - Double Tap', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(
//       home: ObjectRecognition(
//         cameras: [],
//       ),
//     ));

//     // Double tap on the screen.
//     await tester.tap(find.byType(GestureDetector));
//     await tester.pump();
//     await tester.tap(find.byType(GestureDetector));
//     await tester.pump();

//     // Verify that the camera stream is started and values are reset.
//     expect(find.byType(CameraPreview), findsOneWidget);
//     expect(find.text('NO'), findsNothing);
//     expect(find.text('0.0'), findsNothing);
//   });

//   // Add more tests as needed for other functionalities.

//   testWidgets('Object Recognition - Back Button', (WidgetTester tester) async {
//     await tester.pumpWidget(MaterialApp(
//       home: ObjectRecognition(
//         cameras: [],
//       ),
//     ));

//     // Tap on the back button.
//     await tester.tap(find.byType(BackButton));
//     await tester.pump();

//     // Verify that the camera stream is stopped and values are reset.
//     expect(find.byType(CameraPreview), findsNothing);
//     expect(find.text('NO'), findsNothing);
//     expect(find.text('0.0'), findsNothing);
//   });
// }
