import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SearchFilterChip', () {
    testWidgets('renders headerText', (tester) async {
      await tester.pumpApp(
        SearchFilterChip(
          chipText: 'text',
          onSelected: (_) {},
        ),
      );

      expect(find.text('text'), findsOneWidget);
    });

    testWidgets('onSelected gets called on tap', (tester) async {
      final completer = Completer<String>();

      await tester.pumpApp(
        SearchFilterChip(
          chipText: 'text',
          onSelected: completer.complete,
        ),
      );

      await tester.tap(find.byType(SearchFilterChip));

      expect(completer.isCompleted, isTrue);
    });
  });
}
