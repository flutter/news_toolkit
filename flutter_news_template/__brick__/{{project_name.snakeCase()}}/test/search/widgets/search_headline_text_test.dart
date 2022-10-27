import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/search/search.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SearchHeadlineText', () {
    testWidgets('renders headerText uppercased', (tester) async {
      await tester.pumpApp(
        const SearchHeadlineText(
          headerText: 'text',
        ),
      );

      expect(find.text('TEXT'), findsOneWidget);
    });
  });
}
