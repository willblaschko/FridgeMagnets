import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:fridge_magnet_poetry_app/backend_drag_and_drop.dart';
import 'package:fridge_magnet_poetry_app/frontend_drag_and_drop.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('Drag and Drop Interface Tests', () {
    late MockFirestore mockFirestore;
    late DragAndDropService dragAndDropService;

    setUp(() {
      mockFirestore = MockFirestore();
      dragAndDropService = DragAndDropService();
    });

    test('Add magnet position', () async {
      await dragAndDropService.addMagnetPosition('testUser', 'testMagnet', 100.0, 200.0);
      verify(mockFirestore.collection('users').doc('testUser').collection('magnets').doc('testMagnet').set({
        'x': 100.0,
        'y': 200.0,
        'timestamp': anyNamed('timestamp'),
      })).called(1);
    });

    test('Update magnet position', () async {
      await dragAndDropService.updateMagnetPosition('testUser', 'testMagnet', 150.0, 250.0);
      verify(mockFirestore.collection('users').doc('testUser').collection('magnets').doc('testMagnet').update({
        'x': 150.0,
        'y': 250.0,
        'timestamp': anyNamed('timestamp'),
      })).called(1);
    });

    testWidgets('Drag and Drop UI Test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: DragAndDropScreen()));

      // Verify the stack is present
      expect(find.byType(Stack), findsOneWidget);

      // Add a test magnet
      await dragAndDropService.addMagnetPosition('testUser', 'testMagnet', 100.0, 200.0);
      await tester.pumpAndSettle();

      // Verify the magnet is displayed
      expect(find.byType(MagnetWidget), findsWidgets);
    });
  });
}
