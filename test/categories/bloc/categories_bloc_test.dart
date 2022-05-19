// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group('CategoriesBloc', () {
    late NewsRepository newsRepository;

    final categoriesResponse =
        CategoriesResponse(categories: [Category.top, Category.health]);

    setUp(() {
      newsRepository = MockNewsRepository();
    });

    test('can be instantiated', () {
      expect(
        CategoriesBloc(newsRepository: newsRepository),
        isNotNull,
      );
    });

    group('CategoriesRequested', () {
      blocTest<CategoriesBloc, CategoriesState>(
        'emits [loading, populated] '
        'when getCategories succeeds',
        setUp: () => when(newsRepository.getCategories)
            .thenAnswer((_) async => categoriesResponse),
        build: () => CategoriesBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(CategoriesRequested()),
        expect: () => <CategoriesState>[
          CategoriesState(status: CategoriesStatus.loading),
          CategoriesState(
            status: CategoriesStatus.populated,
            categories: categoriesResponse.categories,
          ),
        ],
      );

      blocTest<CategoriesBloc, CategoriesState>(
        'emits [loading, failure] '
        'when getCategories fails',
        setUp: () => when(newsRepository.getCategories).thenThrow(Exception()),
        build: () => CategoriesBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(CategoriesRequested()),
        expect: () => <CategoriesState>[
          CategoriesState(status: CategoriesStatus.loading),
          CategoriesState(status: CategoriesStatus.failure),
        ],
        errors: () => [isA<Exception>()],
      );
    });

    group('CategorySelected', () {
      blocTest<CategoriesBloc, CategoriesState>(
        'emits selectedCategory',
        build: () => CategoriesBloc(newsRepository: newsRepository),
        act: (bloc) => bloc.add(CategorySelected(category: Category.top)),
        expect: () => <CategoriesState>[
          CategoriesState.initial().copyWith(
            selectedCategory: Category.top,
          ),
        ],
      );
    });
  });
}
