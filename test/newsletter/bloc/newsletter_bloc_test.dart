// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:google_news_template/newsletter/newsletter.dart';
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
    test('can be instantiated', () {
      expect(
        NewsletterBloc(newsRepository: newsRepository),
        isNotNull,
      );
    });

    group('NewsletterSubscribed', () {
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
        ).thenThrow(Error),
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

    group('EmailChanged', () {
      final initialState = NewsletterState(email: Email.dirty('test'));
      const newEmail = 'test@test.com';
      blocTest<NewsletterBloc, NewsletterState>(
        'emits changed state '
        'when emailChanged',
        seed: () => initialState,
        build: () => NewsletterBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(EmailChanged(email: newEmail)),
        expect: () => <NewsletterState>[
          initialState.copyWith(email: Email.dirty(newEmail), isValid: true)
        ],
      );
    });
  });
}



  //   group('FeedRequested', () {
  //     blocTest<FeedBloc, FeedState>(
  //       'emits [loading, populated] '
  //       'when getFeed succeeds '
  //       'and there are more news to fetch',
  //       setUp: () => when(
  //         () => newsRepository.getFeed(
  //           category: any(named: 'category'),
  //           offset: any(named: 'offset'),
  //           limit: any(named: 'limit'),
  //         ),
  //       ).thenAnswer((_) async => feedResponse),
  //       build: () => FeedBloc(newsRepository: newsRepository),
  //       act: (bloc) => bloc.add(
  //         FeedRequested(category: Category.entertainment),
  //       ),
  //       expect: () => <FeedState>[
  //         FeedState(status: FeedStatus.loading),
  //         FeedState(
  //           status: FeedStatus.populated,
  //           feed: {
  //             Category.entertainment: feedResponse.feed,
  //           },
  //           hasMoreNews: {
  //             Category.entertainment: true,
  //           },
  //         ),
  //       ],
  //     );

  //     blocTest<FeedBloc, FeedState>(
  //       'emits [loading, populated] '
  //       'with appended feed for the given category '
  //       'when getFeed succeeds '
  //       'and there are no more news to fetch',
  //       seed: () => feedStatePopulated,
  //       setUp: () => when(
  //         () => newsRepository.getFeed(
  //           category: any(named: 'category'),
  //           offset: any(named: 'offset'),
  //           limit: any(named: 'limit'),
  //         ),
  //       ).thenAnswer((_) async => feedResponse),
  //       build: () => FeedBloc(newsRepository: newsRepository),
  //       act: (bloc) => bloc.add(
  //         FeedRequested(category: Category.entertainment),
  //       ),
  //       expect: () => <FeedState>[
  //         feedStatePopulated.copyWith(status: FeedStatus.loading),
  //         feedStatePopulated.copyWith(
  //           status: FeedStatus.populated,
  //           feed: feedStatePopulated.feed
  //             ..addAll({
  //               Category.entertainment: [
  //                 ...feedStatePopulated.feed[Category.entertainment]!,
  //                 ...feedResponse.feed,
  //               ],
  //             }),
  //           hasMoreNews: feedStatePopulated.hasMoreNews
  //             ..addAll({
  //               Category.entertainment: false,
  //             }),
  //         )
  //       ],
  //     );

  //     blocTest<FeedBloc, FeedState>(
  //       'emits [loading, error] '
  //       'when getFeed fails',
  //       setUp: () => when(
  //         () => newsRepository.getFeed(
  //           category: any(named: 'category'),
  //           offset: any(named: 'offset'),
  //           limit: any(named: 'limit'),
  //         ),
  //       ).thenThrow(Exception()),
  //       build: () => FeedBloc(newsRepository: newsRepository),
  //       act: (bloc) => bloc.add(
  //         FeedRequested(category: Category.entertainment),
  //       ),
  //       expect: () => <FeedState>[
  //         FeedState(status: FeedStatus.loading),
  //         FeedState(status: FeedStatus.failure),
  //       ],
  //       errors: () => [isA<Exception>()],
  //     );
  //   });
  // });
// }
