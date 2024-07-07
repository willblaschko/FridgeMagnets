import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:fridge_magnet_poetry_app/backend_custom_word_entry.dart';
import 'package:fridge_magnet_poetry_app/frontend_custom_word_entry.dart';

class MockFirestore extends Mock implements FirebaseFirestore {}
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockUser extends Mock implements User {}

void main() {
  group('Custom Word Entry Tests', () {
    late MockFirestore mockFirestore;
    late MockFirebaseAuth mockFirebaseAuth;
    late CustomWordEntryService customWordEntryService;
    late MockUser mockUser;

    setUp(() {
      mockFirestore = MockFirestore();
      mockFirebaseAuth = MockFirebaseAuth();
      customWordEntryService = CustomWordEntryService();
      mockUser = MockUser();
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
      when(mockUser.uid).thenReturn('testUserId');
    });

    test('Add custom word', () async {
      await customWordEntryService.addCustomWord('testWord');
      verify(mockFirestore.collection('custom_words').add({
        'word': 'testWord',
        'userId': 'testUserId',
        'timestamp': anyNamed('timestamp'),
      })).called(1);
    });

    testWidgets('Custom Word Entry UI Test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: CustomWordEntryScreen()));

      // Verify the input field and button are present
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Add'), findsOneWidget);

      // Enter a word and tap the add button
      await tester.enterText(find.byType(TextField), 'testWord');
      await tester.tap(find.text('Add'));
      await tester.pump();

      // Verify the word is added to the list
      expect(find.text('testWord'), findsOneWidget);
    });
  });
}
