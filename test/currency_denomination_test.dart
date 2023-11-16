import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:sample/Screens/currencyDenomination/currencyDenominations.dart';

class MockCameraController extends Mock implements CameraController {
  // If CameraController's constructor is async, mock its behavior
  MockCameraController() {
    // Mock the behavior of initialize method if it returns a Future<void>
    when(initialize()).thenAnswer((_) async {});

    // Add other method mocks if needed
  }
}

class MockTflite extends Mock implements Tflite {}

void main() {
  testWidgets('Camera is initialized correctly', (tester) async {
    // Create a mock CameraController
    final mockCameraController = MockCameraController();

    // Mock the initialize() method to return a Future<void>
    when(mockCameraController.initialize()).thenAnswer((realInvocation) async {
      // Capture the real invocation
      final realInvoke = realInvocation;

      // Return a Future<void>
      return Future.value();
    });

    CameraDescription mockCameraDescription = mockCameraController.description;

    // Build our app and trigger a frame
    await tester
        .pumpWidget(CurrencyDenomination(cameras: [mockCameraDescription]));

    // Verify that the mock CameraController has been initialized
    verify(mockCameraController.initialize()).called(1);
  });

  testWidgets('Model is loaded correctly', (tester) async {
    // Create a mock Tflite object
    final mockTflite = MockTflite();
    when(mockTflite.loadModel()).thenAnswer((_) async {});

    // Build our app and trigger a frame
    await tester
        .pumpWidget(CurrencyDenomination(cameras: [], tflite: mockTflite));

    // Verify that the mock Tflite object has been loaded correctly
    verify(mockTflite.loadModel()).called(1);
  });

  test('Camera preview is displayed correctly', () async {
    // Create a mock CameraController
    final mockCameraController = MockCameraController();
    // Create a CurrencyDenomination widget with the mock CameraController
    final widget = CurrencyDenomination(cameras: [mockCameraController]);
    // Render the widget
    await widget.pump();
    // Verify that the CameraPreview widget is displayed
    expect(find.byType(CameraPreview), exists);
  });

  test('Recognized object is displayed correctly', () async {
    // Create a mock CameraController
    final mockCameraController = MockCameraController();
    // Create a CurrencyDenomination widget with the mock CameraController
    final widget = CurrencyDenomination(cameras: [mockCameraController]);
    // Render the widget
    await widget.pump();
    // Simulate recognizing an object
    widget._recognizedObject = '100';
    widget._confidenceLevel = 0.9;
    await widget.pump();
    // Verify that the recognized object is displayed
    expect(find.text('100'), exists);
    expect(find.text('0.9'), exists);
  });

  test('Note image is displayed correctly', () async {
    // Create a mock CameraController
    final mockCameraController = MockCameraController();
    // Create a CurrencyDenomination widget with the mock CameraController
    final widget = CurrencyDenomination(cameras: [mockCameraController]);
    // Render the widget
    await widget.pump();
    // Simulate recognizing an object
    widget._recognizedObject = '100';
    widget._confidenceLevel = 0.9;
    await widget.pump();
    // Verify that the note image is displayed
    expect(find.image(AssetImage('assets/images/notes/100b.jpg')), exists);
  });

  test('Module is closed after 10 seconds if no note is detected', () async {
    // Create a mock CameraController
    final mockCameraController = MockCameraController();
    // Create a CurrencyDenomination widget with the mock CameraController
    final widget = CurrencyDenomination(cameras: [mockCameraController]);
    // Render the widget
    await widget.pump();
    // Advance the time by 10 seconds
    await Future.delayed(Duration(seconds: 10));
    // Verify that the module has been closed
    expect(widget._isDetected, false);
  });

  test('Module is opened again after double tap', () async {
    // Create a mock CameraController
    final mockCameraController = MockCameraController();
    // Create a CurrencyDenomination widget with the mock CameraController
    final widget = CurrencyDenomination(cameras: [mockCameraController]);
    // Render the widget
    await widget.pump();
    // Simulate detecting a note
    widget._recognizedObject = '100';
    widget._confidenceLevel = 0.9;
  });

  //main end
}
