import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/facebook_share_button.dart';

import '../../helpers/helpers.dart';

void main() {
  group('FacebookShareButton', () {
    testWidgets('calls onPress when tapped', (tester) async {
      final completer = Completer<void>();
      await tester.pumpContentThemedApp(
        FacebookShareButton(
          onTap: completer.complete,
        ),
      );

      await tester.tap(find.byType(FacebookShareButton));

      expect(completer.isCompleted, isTrue);
    });
  });
}
