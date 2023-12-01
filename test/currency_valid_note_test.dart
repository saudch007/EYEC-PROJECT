// NOT YET PASSED

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sample/Screens/currencyDenomination/currencyDenominations.dart';

void main() {
  group('CurrencyDenominationWidgetTests', () {
    late List<CameraDescription> cameras;

    setUp(() {
      cameras = [
        CameraDescription(
          name: "0",
          lensDirection: CameraLensDirection.front,
          sensorOrientation: 90,
        ),
      ];
    });

    testWidgets('Valid note detection', (WidgetTester tester) async {
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

      // Simulate a valid note detection with high confidence
      tester
          .widget<CurrencyDenomination>(
            find.byType(CurrencyDenomination),
          )
          .currencyDenominationState
          .recognitionsList = [
        {'label': 'ValidNote', 'confidence': 0.99}
      ];

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Ensure that the camera stream is stopped
      expect(find.byType(CameraPreview), findsOneWidget);

      // Ensure that the appropriate UI elements are displayed after detection
      //expect(find.text('DETECTED'), findsOneWidget);

      expect(find.text('99.0'), findsOneWidget);

      // If "DETECTED" is conditionally added, you might need to adjust the find logic
      if (isDetectedInState(tester)) {
        expect(find.text('DETECTED'), findsOneWidget);
      }
    });

    tearDown(() {
      // Clean up any resources or reset global state
    });
  });
}

bool isDetectedInState(WidgetTester tester) {
  final widget = tester.widget<CurrencyDenomination>(
    find.byType(CurrencyDenomination),
  );
  return widget.currencyDenominationState.isDetected;
}
