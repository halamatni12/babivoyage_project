import 'package:flutter_test/flutter_test.dart';
import 'package:babibeauty_app/app/app.dart';

void main() {
  testWidgets('App loads', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Login Screen'), findsOneWidget);
  });
}