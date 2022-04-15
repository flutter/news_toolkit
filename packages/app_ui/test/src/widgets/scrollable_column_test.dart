// ignore_for_file: prefer_const_constructors
import 'package:app_ui/app_ui.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ScrollableColumn', () {
    testWidgets('renders children', (tester) async {
      await tester.pumpWidget(
        ScrollableColumn(
          children: const [
            SizedBox(),
            SizedBox(),
            SizedBox(),
          ],
        ),
      );
      expect(find.byType(SizedBox), findsNWidgets(3));
    });

    testWidgets('is scrollable', (tester) async {
      const key = Key('__target__');
      await tester.pumpWidget(
        ScrollableColumn(
          children: const [
            SizedBox(height: 1000),
            SizedBox(),
            SizedBox(key: key),
          ],
        ),
      );
      await tester.ensureVisible(find.byKey(key));
      expect(tester.takeException(), isNull);
    });
  });
}
