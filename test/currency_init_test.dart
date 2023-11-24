// Unit tests
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
            sensorOrientation: 90)
      ]; // Initialize with appropriate CameraDescription objects
    });

    testWidgets('Widget initializes correctly', (WidgetTester tester) async {
      // Build our widget and trigger a frame.
      await tester.pumpWidget(
        MaterialApp(
          home: CurrencyDenomination(cameras: cameras),
        ),
      );

      await tester.pumpAndSettle();

      // Verify that the widget has the expected initial state
      expect(find.text('DETECTED'), findsNothing);
      expect(find.byType(CameraPreview), findsOneWidget);
      expect(find.text('NO'), findsOneWidget);
      expect(find.text('0.0'), findsOneWidget);
    });

    // Add more tests as needed for various scenarios

    tearDown(() {
      // Clean up any resources or reset global state
    });
  });
}
