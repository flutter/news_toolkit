import 'package:article_repository/article_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storage/storage.dart';
import 'package:test/test.dart';

class MockStorage extends Mock implements Storage {}

void main() {
  group('ArticleStorage', () {
    late Storage storage;

    setUp(() {
      storage = MockStorage();

      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
    });

    group('setArticleViews', () {
      test('saves the value in Storage', () async {
        const views = 3;

        await ArticleStorage(storage: storage).setArticleViews(views);

        verify(
          () => storage.write(
            key: ArticleStorageKeys.articleViews,
            value: views.toString(),
          ),
        ).called(1);
      });
    });

    group('fetchArticleViews', () {
      test('returns the value from Storage', () async {
        when(
          () => storage.read(key: ArticleStorageKeys.articleViews),
        ).thenAnswer((_) async => '3');

        final result =
            await ArticleStorage(storage: storage).fetchArticleViews();

        verify(
          () => storage.read(
            key: ArticleStorageKeys.articleViews,
          ),
        ).called(1);

        expect(result, equals(3));
      });

      test('returns 0 when no value exists in Storage', () async {
        when(
          () => storage.read(key: ArticleStorageKeys.articleViews),
        ).thenAnswer((_) async => null);

        final result =
            await ArticleStorage(storage: storage).fetchArticleViews();

        verify(
          () => storage.read(
            key: ArticleStorageKeys.articleViews,
          ),
        ).called(1);

        expect(result, isZero);
      });
    });

    group('setArticleViewsResetDate', () {
      test('saves the value in Storage', () async {
        final date = DateTime(2022, 6, 7);

        await ArticleStorage(storage: storage).setArticleViewsResetDate(date);

        verify(
          () => storage.write(
            key: ArticleStorageKeys.articleViewsResetAt,
            value: date.toIso8601String(),
          ),
        ).called(1);
      });
    });

    group('fetchArticleViewsResetDate', () {
      test('returns the value from Storage', () async {
        final date = DateTime(2022, 6, 7);

        when(
          () => storage.read(key: ArticleStorageKeys.articleViewsResetAt),
        ).thenAnswer((_) async => date.toIso8601String());

        final result =
            await ArticleStorage(storage: storage).fetchArticleViewsResetDate();

        verify(
          () => storage.read(
            key: ArticleStorageKeys.articleViewsResetAt,
          ),
        ).called(1);

        expect(result, equals(date));
      });

      test('returns null when no value exists in Storage', () async {
        when(
          () => storage.read(key: ArticleStorageKeys.articleViewsResetAt),
        ).thenAnswer((_) async => null);

        final result =
            await ArticleStorage(storage: storage).fetchArticleViewsResetDate();

        verify(
          () => storage.read(
            key: ArticleStorageKeys.articleViewsResetAt,
          ),
        ).called(1);

        expect(result, isNull);
      });
    });

    group('setTotalArticleViews', () {
      test('saves the value in Storage', () async {
        const views = 3;

        await ArticleStorage(storage: storage).setTotalArticleViews(views);

        verify(
          () => storage.write(
            key: ArticleStorageKeys.totalArticleViews,
            value: views.toString(),
          ),
        ).called(1);
      });
    });

    group('fetchTotalArticleViews', () {
      test('returns the value from Storage', () async {
        when(
          () => storage.read(key: ArticleStorageKeys.totalArticleViews),
        ).thenAnswer((_) async => '3');

        final result =
            await ArticleStorage(storage: storage).fetchTotalArticleViews();

        verify(
          () => storage.read(
            key: ArticleStorageKeys.totalArticleViews,
          ),
        ).called(1);

        expect(result, equals(3));
      });

      test('returns 0 when no value exists in Storage', () async {
        when(
          () => storage.read(key: ArticleStorageKeys.totalArticleViews),
        ).thenAnswer((_) async => null);

        final result =
            await ArticleStorage(storage: storage).fetchTotalArticleViews();

        verify(
          () => storage.read(
            key: ArticleStorageKeys.totalArticleViews,
          ),
        ).called(1);

        expect(result, isZero);
      });

      test('returns 0 when stored value is malformed', () async {
        when(
          () => storage.read(key: ArticleStorageKeys.totalArticleViews),
        ).thenAnswer((_) async => 'malformed');

        final result =
            await ArticleStorage(storage: storage).fetchTotalArticleViews();

        verify(
          () => storage.read(
            key: ArticleStorageKeys.totalArticleViews,
          ),
        ).called(1);

        expect(result, isZero);
      });
    });
  });
}
