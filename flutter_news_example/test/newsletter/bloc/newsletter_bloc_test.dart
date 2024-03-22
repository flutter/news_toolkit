// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/newsletter/newsletter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late NewsRepository newsRepository;
  const emailValid = Email.dirty('test');

  setUpAll(() {
    newsRepository = MockNewsRepository();
  });

  group('NewsletterBloc', () {
    group('on NewsletterSubscribed', () {
      blocTest<NewsletterBloc, NewsletterState>(
        'emits [loading, success] '
        'when subscribeToNewsletter succeeds',
        setUp: () => when(
          () => newsRepository.subscribeToNewsletter(
            email: any(named: 'email'),
          ),
        ).thenAnswer(Future.value),
        seed: () => NewsletterState(email: Email.dirty('test'), isValid: true),
        build: () => NewsletterBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(NewsletterSubscribed()),
        expect: () => <NewsletterState>[
          NewsletterState(
            status: NewsletterStatus.loading,
            email: emailValid,
            isValid: true,
          ),
          NewsletterState(
            status: NewsletterStatus.success,
            email: emailValid,
            isValid: true,
          ),
        ],
      );

      blocTest<NewsletterBloc, NewsletterState>(
        'emits [loading, failed] '
        'when subscribeToNewsletter throws',
        setUp: () => when(
          () => newsRepository.subscribeToNewsletter(
            email: any(named: 'email'),
          ),
        ).thenThrow(Error.new),
        seed: () => NewsletterState(email: Email.dirty('test')),
        build: () => NewsletterBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(NewsletterSubscribed()),
        expect: () => <NewsletterState>[
          NewsletterState(
            status: NewsletterStatus.loading,
            email: emailValid,
          ),
          NewsletterState(
            status: NewsletterStatus.failure,
            email: emailValid,
          ),
        ],
      );

      blocTest<NewsletterBloc, NewsletterState>(
        'emits nothing '
        'when email is empty',
        seed: () => NewsletterState(email: Email.dirty()),
        build: () => NewsletterBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(NewsletterSubscribed()),
        expect: () => <NewsletterState>[],
      );
    });

    group('on EmailChanged', () {
      final initialState = NewsletterState(email: Email.dirty('test'));
      const newEmail = 'test@test.com';

      blocTest<NewsletterBloc, NewsletterState>(
        'emits changed state '
        'when emailChanged',
        seed: () => initialState,
        build: () => NewsletterBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(EmailChanged(email: newEmail)),
        expect: () => <NewsletterState>[
          initialState.copyWith(email: Email.dirty(newEmail), isValid: true),
        ],
      );
    });
  });
}
