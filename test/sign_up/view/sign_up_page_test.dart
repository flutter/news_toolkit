// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/sign_up/sign_up.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  const leftCrossIconKey = Key('signUpPage_crossIcon');

  group('SignUpPage', () {
    test('has a route', () {
      expect(SignUpPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a SignUpForm', (tester) async {
      await tester.pumpApp(SignUpPage());
      expect(find.byType(SignUpForm), findsOneWidget);
    });
  });

  group('closes page', () {
    testWidgets('when left cross icon is pressed', (tester) async {
      final navigator = MockNavigator();
      when(navigator.pop).thenAnswer((_) async {});
      await tester.pumpApp(
        SignUpPage(),
        navigator: navigator,
      );
      await tester.tap(find.byKey(leftCrossIconKey));
      await tester.pumpAndSettle();
      verify(navigator.pop).called(1);
    });
  });
}
