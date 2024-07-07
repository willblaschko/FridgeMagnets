import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:fridge_magnet_poetry_app/backend_fridge_door_background.dart';
import 'package:fridge_magnet_poetry_app/frontend_fridge_door_background.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('Fridge Door Background Tests', () {
    late MockFirestore mockFirestore;
    late FridgeDoorBackgroundService fridgeDoorBackgroundService;

    setUp(() {
      mockFirestore = MockFirestore();
      fridgeDoorBackgroundService = FridgeDoorBackgroundService();
    });

    test('Add fridge door background', () async {
      await fridgeDoorBackgroundService.addFridgeDoorBackground('testImageUrl');
      verify(mockFirestore.collection('fridge_door_backgrounds').add({
        'imageUrl': 'testImageUrl',
        'timestamp': anyNamed('timestamp'),
      })).called(1);
    });

    testWidgets('Fridge Door Background UI Test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: FridgeDoorBackgroundScreen()));

      // Verify the list view is present
      expect(find.byType(ListView), findsOneWidget);

      // Add a test background image
      await fridgeDoorBackgroundService.addFridgeDoorBackground('testImageUrl');
      await tester.pumpAndSettle();

      // Verify the background image is displayed
      expect(find.byType(Container), findsWidgets);
    });
  });
}
