import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/search/widgets/widgets.dart';

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
