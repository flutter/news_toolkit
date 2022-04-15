// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/reset_password/reset_password.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ResetPasswordPage', () {
    test('has a route', () {
      expect(ResetPasswordPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpApp(ResetPasswordPage());
      expect(find.byType(ResetPasswordForm), findsOneWidget);
    });
  });
}
