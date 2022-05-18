import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/navigation/navigation.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BottomNavBar', () {
    testWidgets(
      'renders with currentIndex to 0 by default.',
      (tester) async {
        await tester.pumpApp(
          BottomNavBar(
            currentIndex: 0,
            onTap: (selectedIndex) {},
          ),
        );
        expect(find.byType(BottomNavBar), findsOneWidget);
      },
    );
  });
}
