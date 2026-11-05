import 'package:flutter_test/flutter_test.dart';
import 'package:notice_board/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('shows empty state, then validation errors on empty form',
      (tester) async {
    await tester.pumpWidget(const NoticeBoardApp());
    await tester.pumpAndSettle();

    expect(find.text('No notices yet'), findsOneWidget);

    await tester.tap(find.text('Post notice'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Publish'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a title'), findsOneWidget);
    expect(find.text('Choose a department'), findsOneWidget);
    expect(find.text('Enter the notice details'), findsOneWidget);
  });
}
