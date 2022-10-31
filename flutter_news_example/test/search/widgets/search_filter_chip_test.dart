import 'dart:async';

import 'package:flutter_news_example/search/search.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SearchFilterChip', () {
    testWidgets('renders chipText', (tester) async {
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
