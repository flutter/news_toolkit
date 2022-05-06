import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/magic_link_prompt/view/view.dart';

import '../../helpers/helpers.dart';

void main() {
  const testEmail = 'test@gmail.com';

  group('MagicLinkPromptView', () {
    group('renders', () {
      testWidgets('MagicLinkPromptHeader', (tester) async {
        await tester.pumpApp(const MagicLinkPromptView(email: testEmail));
        expect(find.byType(MagicLinkPromptHeader), findsOneWidget);
      });

      testWidgets('MagicLinkPromptSubtitle', (tester) async {
        await tester.pumpApp(const MagicLinkPromptView(email: testEmail));
        expect(find.byType(MagicLinkPromptSubtitle), findsOneWidget);
      });

      testWidgets('MagicLinkPromptOpenEmailButton', (tester) async {
        await tester.pumpApp(const MagicLinkPromptView(email: testEmail));
        expect(find.byType(MagicLinkPromptOpenEmailButton), findsOneWidget);
      });
    });

    group('does nothing', () {
      testWidgets(
        'when MagicLinkPromptOpenEmailButton is pressed',
        (tester) async {
          await tester.pumpApp(const MagicLinkPromptView(email: testEmail));
          final button = find.byType(MagicLinkPromptOpenEmailButton);
          await tester.tap(button);
          await tester.pumpAndSettle();
        },
      );
    });
  });
}
