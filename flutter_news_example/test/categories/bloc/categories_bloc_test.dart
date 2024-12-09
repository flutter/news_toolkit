// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  initMockHydratedStorage();

  group('CategoriesBloc', () {
    late NewsRepository newsRepository;
    late CategoriesBloc categoriesBloc;

    final sportsCategory = Category(id: 'sports', name: 'Sports');
    final healthCategory = Category(id: 'health', name: 'Health');

    final categoriesResponse = CategoriesResponse(
      categories: [sportsCategory, healthCategory],
    );

    setUp(() async {
      newsRepository = MockNewsRepository();
      categoriesBloc = CategoriesBloc(newsRepository: newsRepository);
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
        act: (bloc) => bloc.add(CategorySelected(category: sportsCategory)),
        expect: () => <CategoriesState>[
          CategoriesState.initial().copyWith(
            selectedCategory: sportsCategory,
          ),
        ],
      );
    });
  });
}
