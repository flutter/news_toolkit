import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/login/login.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoginModal', () {
    test('has a route', () {
      expect(LoginModal.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpApp(const LoginModal());
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
