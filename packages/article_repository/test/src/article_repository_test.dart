import 'package:article_repository/article_repository.dart';
import 'package:clock/clock.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockArticleStorage extends Mock implements ArticleStorage {}

void main() {
  group('ArticleRepository', () {
    late ArticleStorage storage;

    setUp(() {
      storage = MockArticleStorage();
      when(() => storage.setArticleViews(any())).thenAnswer((_) async {});
      when(() => storage.setArticleViewsResetDate(any()))
          .thenAnswer((_) async {});
    });

    test('can be instantiated', () {
      expect(ArticleRepository(storage: storage), isNotNull);
    });

    group('incrementArticleViews', () {
      test(
          'calls ArticleStorage.setArticleViews '
          'with current article views increased by 1', () async {
        const currentArticleViews = 3;
        when(storage.fetchArticleViews)
            .thenAnswer((_) async => currentArticleViews);

        await ArticleRepository(storage: storage).incrementArticleViews();

        verify(storage.fetchArticleViews).called(1);
        verify(() => storage.setArticleViews(currentArticleViews + 1))
            .called(1);
      });

      test(
          'throws an IncrementArticleViewsFailure '
          'when incrementing article views fails', () async {
        when(() => storage.setArticleViews(any())).thenThrow(Exception());

        expect(
          () => ArticleRepository(storage: storage).incrementArticleViews(),
          throwsA(isA<IncrementArticleViewsFailure>()),
        );
      });
    });

    group('resetArticleViews', () {
      test(
          'calls ArticleStorage.setArticleViews '
          'with 0 article views', () async {
        await ArticleRepository(storage: storage).resetArticleViews();
        verify(() => storage.setArticleViews(0)).called(1);
      });

      test(
          'calls ArticleStorage.setArticleViewsResetDate '
          'with current date', () async {
        final now = DateTime(2022, 6, 7);
        await withClock(Clock.fixed(now), () async {
          await ArticleRepository(storage: storage).resetArticleViews();
          verify(() => storage.setArticleViewsResetDate(now)).called(1);
        });
      });

      test(
          'throws a ResetArticleViewsFailure '
          'when resetting article views fails', () async {
        when(() => storage.setArticleViews(any())).thenThrow(Exception());

        expect(
          () => ArticleRepository(storage: storage).resetArticleViews(),
          throwsA(isA<ResetArticleViewsFailure>()),
        );
      });
    });

    group('fetchArticleViews', () {
      test(
          'returns the number of article views '
          'from ArticleStorage.fetchArticleViews', () async {
        const currentArticleViews = 3;
        when(storage.fetchArticleViews)
            .thenAnswer((_) async => currentArticleViews);
        when(storage.fetchArticleViewsResetDate).thenAnswer((_) async => null);
        final result =
            await ArticleRepository(storage: storage).fetchArticleViews();
        expect(result.views, equals(currentArticleViews));
      });

      test(
          'returns the reset date of the number of article views '
          'from ArticleStorage.fetchArticleViewsResetDate', () async {
        final resetDate = DateTime(2022, 6, 7);
        when(storage.fetchArticleViews).thenAnswer((_) async => 0);
        when(storage.fetchArticleViewsResetDate)
            .thenAnswer((_) async => resetDate);
        final result =
            await ArticleRepository(storage: storage).fetchArticleViews();
        expect(result.resetAt, equals(resetDate));
      });

      test(
          'throws a FetchArticleViewsFailure '
          'when fetching article views fails', () async {
        when(storage.fetchArticleViews).thenThrow(Exception());

        expect(
          () => ArticleRepository(storage: storage).fetchArticleViews(),
          throwsA(isA<FetchArticleViewsFailure>()),
        );
      });
    });

    group('ArticleFailure', () {
      final error = Exception('errorMessage');

      group('IncrementArticleViewsFailure', () {
        test('has correct props', () {
          expect(IncrementArticleViewsFailure(error).props, [error]);
        });
      });

      group('ResetArticleViewsFailure', () {
        test('has correct props', () {
          expect(ResetArticleViewsFailure(error).props, [error]);
        });
      });

      group('FetchArticleViewsFailure', () {
        test('has correct props', () {
          expect(FetchArticleViewsFailure(error).props, [error]);
        });
      });
    });
  });
}
