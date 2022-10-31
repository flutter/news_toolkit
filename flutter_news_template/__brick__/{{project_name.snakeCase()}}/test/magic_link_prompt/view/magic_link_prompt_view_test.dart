import 'package:email_launcher/email_launcher.dart';
import 'package:{{project_name.snakeCase()}}/magic_link_prompt/magic_link_prompt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockEmailLauncher extends Mock implements EmailLauncher {}

void main() {
  const testEmail = 'test@gmail.com';
  late EmailLauncher emailLauncher;

  setUp(() {
    emailLauncher = MockEmailLauncher();
  });

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

    group('opens default email app', () {
      testWidgets(
        'when MagicLinkPromptOpenEmailButton is pressed',
        (tester) async {
          when(emailLauncher.launchEmailApp).thenAnswer((_) async {});
          await tester.pumpApp(
            MagicLinkPromptOpenEmailButton(
              emailLauncher: emailLauncher,
            ),
          );

          await tester.tap(find.byType(MagicLinkPromptOpenEmailButton));
          await tester.pumpAndSettle();
          verify(emailLauncher.launchEmailApp).called(1);
        },
      );
    });
  });
}
