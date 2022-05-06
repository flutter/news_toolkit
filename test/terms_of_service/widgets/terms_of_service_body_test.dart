// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/terms_of_service/terms_of_service.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TermsOfServiceBody', () {
    group('renders', () {
      testWidgets('terms of service modal body', (tester) async {
        await tester.pumpApp(TermsOfServiceModal());
        expect(find.byType(TermsOfServiceModalBody), findsOneWidget);
      });
    });
  });
}
