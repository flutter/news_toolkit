// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/home/home.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late NewsRepository newsRepository;

  setUpAll(initMockHydratedStorage);

  setUp(() {
    newsRepository = MockNewsRepository();

    when(newsRepository.getCategories).thenAnswer(
      (_) async => CategoriesResponse(
        categories: [Category.top],
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
      const HomePage(),
      newsRepository: newsRepository,
    );

    expect(find.byType(FeedView), findsOneWidget);
  });
}
