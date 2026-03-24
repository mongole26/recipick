import 'package:flutter_test/flutter_test.dart';
import 'package:recipick/app/app.dart';

void main() {
  testWidgets('App renders ingredient input screen', (WidgetTester tester) async {
    await tester.pumpWidget(const RecipickApp());
    expect(find.text('냉장고 재료 등록'), findsOneWidget);
  });
}
