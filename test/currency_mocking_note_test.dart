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

    testWidgets('Initial camera state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CurrencyDenomination(cameras: cameras),
        ),
      );

      // Wait for camera initialization
      await tester.pumpAndSettle();

      // Ensure that the camera preview is visible
      expect(find.byType(CameraPreview), findsOneWidget);

      // Ensure that detection-related widgets are not present initially
      expect(find.text('DETECTED'), findsNothing);
      expect(find.text('recognizedObject'), findsNothing);
      expect(find.text('confidenceLevel'), findsNothing);
    });

    testWidgets('Note detection', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CurrencyDenomination(cameras: cameras),
        ),
      );

      // Wait for camera initialization
      await tester.pumpAndSettle();

      // Simulate a valid note detection with high confidence
      tester
          .widget<CurrencyDenomination>(
            find.byType(CurrencyDenomination),
          )
          .currencyDenominationState
          .recognitionsList = [
        {'label': 'ValidNote', 'confidence': 0.99}
      ];

      // Wait for a certain period to ensure all asynchronous operations are settled
      //await Future.delayed(Duration(seconds: 2));

      // Wait for all asynchronous operations to complete.
      await tester.pumpAndSettle();

      // Ensure that the camera preview is not visible after detection
      expect(find.byType(CameraPreview), findsNothing);

      // Ensure that the appropriate UI elements are displayed after detection
      expect(find.text('DETECTED'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.text('ValidNote'), findsOneWidget);
      expect(find.text('99.0'), findsOneWidget);
    });

    // Add more tests as needed for various scenarios

    tearDown(() {
      // Clean up any resources or reset global state
    });
  });
}
