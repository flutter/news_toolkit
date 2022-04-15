// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/sign_up/sign_up.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpPage', () {
    test('has a route', () {
      expect(SignUpPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpApp(SignUpPage());
      expect(find.byType(SignUpForm), findsOneWidget);
    });
  });
}
