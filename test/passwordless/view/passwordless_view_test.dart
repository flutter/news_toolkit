import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/passwordless/view/view.dart';

import '../../helpers/helpers.dart';

void main() {
  const testEmail = 'test@gmail.com';

  group('PasswordlessView', () {
    group('renders', () {
      testWidgets('PasswordlessHeader', (tester) async {
        await tester.pumpApp(const PasswordlessView(email: testEmail));
        expect(find.byType(PasswordlessHeader), findsOneWidget);
      });

      testWidgets('PasswordlessSubtitle', (tester) async {
        await tester.pumpApp(const PasswordlessView(email: testEmail));
        expect(find.byType(PasswordlessSubtitle), findsOneWidget);
      });

      testWidgets('PasswordlessOpenEmailButton', (tester) async {
        await tester.pumpApp(const PasswordlessView(email: testEmail));
        expect(find.byType(PasswordlessOpenEmailButton), findsOneWidget);
      });
    });

    group('do nothing', () {
      testWidgets(
        'when PasswordlessOpenEmailButton is pressed',
        (tester) async {
          await tester.pumpApp(const PasswordlessView(email: testEmail));
          final button = find.byType(PasswordlessOpenEmailButton);
          await tester.tap(button);
          await tester.pumpAndSettle();
        },
      );
    });
  });
}
