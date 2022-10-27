// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group('CategoriesBloc', () {
    late NewsRepository newsRepository;
    late CategoriesBloc categoriesBloc;

    final categoriesResponse =
        CategoriesResponse(categories: [Category.top, Category.health]);

    setUpAll(initMockHydratedStorage);

    setUp(() async {
      newsRepository = MockNewsRepository();
      categoriesBloc = CategoriesBloc(newsRepository: newsRepository);
    });

    test('can be instantiated', () {
      expect(
        categoriesBloc,
        isNotNull,
      );
    });

    test('can be (de)serialized', () {
      final categoriesState = CategoriesState(
        status: CategoriesStatus.populated,
        categories: categoriesResponse.categories,
        selectedCategory: categoriesResponse.categories.first,
      );

      final serialized = categoriesBloc.toJson(categoriesState);
      final deserialized = categoriesBloc.fromJson(serialized!);

      expect(deserialized, categoriesState);
    });

    group('CategoriesRequested', () {
      blocTest<CategoriesBloc, CategoriesState>(
        'emits [loading, populated] '
        'when getCategories succeeds',
        setUp: () => when(newsRepository.getCategories)
            .thenAnswer((_) async => categoriesResponse),
        build: () => categoriesBloc,
        act: (bloc) => bloc.add(CategoriesRequested()),
        expect: () => <CategoriesState>[
          CategoriesState(status: CategoriesStatus.loading),
          CategoriesState(
            status: CategoriesStatus.populated,
            categories: categoriesResponse.categories,
            selectedCategory: categoriesResponse.categories.first,
          ),
        ],
      );

      blocTest<CategoriesBloc, CategoriesState>(
        'emits [loading, failure] '
        'when getCategories fails',
        setUp: () => when(newsRepository.getCategories).thenThrow(Exception()),
        build: () => categoriesBloc,
        act: (bloc) => bloc.add(CategoriesRequested()),
        expect: () => <CategoriesState>[
          CategoriesState(status: CategoriesStatus.loading),
          CategoriesState(status: CategoriesStatus.failure),
        ],
      );
    });

    group('CategorySelected', () {
      blocTest<CategoriesBloc, CategoriesState>(
        'emits selectedCategory',
        build: () => categoriesBloc,
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
