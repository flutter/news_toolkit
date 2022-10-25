// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:flutter_news_template/newsletter/newsletter.dart';

void main() {
  group('NewsletterState', () {
    test('initial has correct status', () {
      expect(
        NewsletterState().status,
        equals(NewsletterStatus.initial),
      );
    });

    group('copyWith', () {
      test(
          'returns same object '
          'when no properties are passed', () {
        expect(
          NewsletterState().copyWith(),
          equals(NewsletterState()),
        );
      });

      test(
          'returns object with updated status '
          'when status is passed', () {
        expect(
          NewsletterState().copyWith(
            status: NewsletterStatus.loading,
          ),
          equals(
            NewsletterState(
              status: NewsletterStatus.loading,
            ),
          ),
        );
      });

      test(
          'returns object with updated email '
          'when status is passed', () {
        expect(
          NewsletterState().copyWith(
            email: Email.dirty('email'),
          ),
          equals(
            NewsletterState(
              email: Email.dirty('email'),
            ),
          ),
        );
      });

      test(
          'returns object with updated isValid '
          'when status is passed', () {
        expect(
          NewsletterState().copyWith(
            isValid: true,
          ),
          equals(
            NewsletterState(
              isValid: true,
            ),
          ),
        );
      });
    });
  });
}
