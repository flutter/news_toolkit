import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/share_button.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ShareButton', () {
    testWidgets('calls onPress when tapped', (tester) async {
      final completer = Completer<void>();
      await tester.pumpContentThemedApp(
        ShareButton(
          shareText: 'shareText',
          onPressed: completer.complete,
        ),
      );

      await tester.tap(find.byType(ShareButton));

      expect(completer.isCompleted, isTrue);
    });
  });
}
