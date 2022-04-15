import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/login/login.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoginPage', () {
    test('is routable', () {
      expect(LoginPage.page(), isA<MaterialPage>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpApp(const LoginPage());
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
