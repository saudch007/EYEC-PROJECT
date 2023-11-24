import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/Screens/currencyDenomination/currencyDenominations.dart';

void main() {
  group('CurrencyDenominationWidgetTests', () {
    late List<CameraDescription> cameras;

    setUp(() {
      // Initialize any necessary data or dependencies

      cameras = [
        CameraDescription(
          name: "0",
          lensDirection: CameraLensDirection.front,
          sensorOrientation: 90,
        ),
      ];
    });

    testWidgets('Widget disposes correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: CurrencyDenomination(cameras: cameras),
        ),
      );

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Ensure that the camera stream is initially running
      expect(find.byType(CameraPreview), findsOneWidget);

      // Dispose the widget
      await tester.pumpWidget(Container()); // Replace with a new widget

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Ensure that the camera stream is stopped after disposal
      expect(find.byType(CameraPreview), findsNothing);
    });

    // Add more tests as needed for various scenarios

    tearDown(() {
      // Clean up any resources or reset global state
    });
  });
}
