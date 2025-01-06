// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  initMockHydratedStorage();

  late NewsRepository newsRepository;
  late GoRouter router;

  setUp(() {
    newsRepository = MockNewsRepository();
    router = MockGoRouter();
    final healthCategory = Category(id: 'health', name: 'Health');

    when(newsRepository.getCategories).thenAnswer(
      (_) async => CategoriesResponse(
        categories: [healthCategory],
      ),
    );
  });

  test('has a page', () {
    expect(HomePage.page(), isA<MaterialPage<void>>());
  });

  testWidgets('renders a HomeView', (tester) async {
    await tester.pumpApp(const HomePage());

    expect(find.byType(HomeView), findsOneWidget);
  });

  testWidgets('renders FeedView', (tester) async {
    await tester.pumpApp(
      InheritedGoRouter(goRouter: router, child: const HomePage()),
      newsRepository: newsRepository,
    );

    expect(find.byType(FeedView), findsOneWidget);
  });
}
