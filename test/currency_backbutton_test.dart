// This test has some work remaining
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

    testWidgets('Back button stops camera stream', (WidgetTester tester) async {
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

      // Simulate pressing the back button
      Navigator.of(tester.element(find.byType(CurrencyDenomination))).pop();

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Rebuild the widget after the pop
      await tester.pumpWidget(Container());

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Ensure that the camera stream is stopped and _isDetected is false
      expect(find.byType(CameraPreview), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(_isDetectedInState(tester), false);
    });

    // Add more tests as needed for various scenarios

    tearDown(() {
      // Clean up any resources or reset global state
    });
  });
}

bool _isDetectedInState(WidgetTester tester) {
  final widget = tester.widget<CurrencyDenomination>(
    find.byType(CurrencyDenomination),
  );
  return widget.currencyDenominationState.isDetected;
}
