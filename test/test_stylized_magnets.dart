import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:fridge_magnet_poetry_app/backend_stylized_magnets.dart';
import 'package:fridge_magnet_poetry_app/frontend_stylized_magnets.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}

void main() {
  group('Stylized Magnets Tests', () {
    late MockFirestore mockFirestore;
    late StylizedMagnetsService stylizedMagnetsService;

    setUp(() {
      mockFirestore = MockFirestore();
      stylizedMagnetsService = StylizedMagnetsService();
    });

    test('Add magnet style', () async {
      await stylizedMagnetsService.addMagnetStyle('testStyle', {'color': 'blue'});
      verify(mockFirestore.collection('magnet_styles').add({
        'styleName': 'testStyle',
        'styleData': {'color': 'blue'},
        'timestamp': anyNamed('timestamp'),
      })).called(1);
    });

    testWidgets('Stylized Magnets UI Test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: StylizedMagnetsScreen()));

      // Verify the dropdowns are present
      expect(find.text('Select Style'), findsOneWidget);
      expect(find.text('Select Font'), findsOneWidget);

      // Select a style and font
      await tester.tap(find.text('Select Style'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('testStyle').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Select Font'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Arial').last);
      await tester.pumpAndSettle();

      // Verify the selected style and font are applied
      expect(find.text('testStyle'), findsOneWidget);
      expect(find.text('Arial'), findsOneWidget);
    });
  });
}
