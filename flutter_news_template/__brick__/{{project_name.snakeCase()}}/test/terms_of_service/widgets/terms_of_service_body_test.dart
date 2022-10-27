// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:{{project_name.snakeCase()}}/terms_of_service/terms_of_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  const termsOfServiceBodyTextKey = Key('termsOfServiceBody_text');

  group('TermsOfServiceBody', () {
    group('renders', () {
      testWidgets('SingleChildScrollView', (tester) async {
        await tester.pumpApp(
          Column(
            children: const [
              TermsOfServiceBody(),
            ],
          ),
        );
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('terms of service body text', (tester) async {
        await tester.pumpApp(
          Column(
            children: const [
              TermsOfServiceBody(),
            ],
          ),
        );
        expect(find.byKey(termsOfServiceBodyTextKey), findsOneWidget);
      });
    });
  });
}
