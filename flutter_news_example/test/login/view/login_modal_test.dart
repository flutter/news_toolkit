import 'package:flutter/material.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoginModal', () {
    test('has a route', () {
      expect(LoginModal.route(), isA<MaterialPageRoute<void>>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpApp(const LoginModal());
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
