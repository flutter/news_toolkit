// ignore_for_file: prefer_const_constructors
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_blocks_ui/src/widgets/widgets.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LockIcon', () {
    testWidgets('renders correctly', (tester) async {
      await tester.pumpApp(LockIcon());

      expect(find.byType(Icon), findsOneWidget);
    });
  });
}
