// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

void main() {
  late NewsRepository newsRepository;
  late HomeCubit cubit;

  setUp(() {
    newsRepository = MockNewsRepository();
    cubit = MockHomeCubit();
    when(() => cubit.state).thenReturn(const HomeState());

    when(newsRepository.getCategories).thenAnswer(
      (_) async => CategoriesResponse(
        categories: [Category.top],
      ),
    );
  });

  test('has a page', () {
    expect(HomePage.page(), isA<MaterialPage>());
  });

  testWidgets('renders FeedView', (tester) async {
    await tester.pumpApp(
      BlocProvider(
        create: (context) => HomeCubit(),
        child: HomePage(),
      ),
      newsRepository: newsRepository,
    );
    expect(find.byType(FeedView), findsOneWidget);
  });

  group('BottomNav', () {
    testWidgets(
      'has selected index to 0 by default.',
      (tester) async {
        when(() => cubit.state).thenReturn(const HomeState());

        await tester.pumpApp(
          BlocProvider.value(
            value: cubit,
            child: HomePage(),
          ),
        );

        expect(find.byType(FeedView), findsOneWidget);
      },
    );

    testWidgets(
      'set tab to selected index 0 when top stories is tapped.',
      (tester) async {
        await tester.pumpApp(
          BlocProvider.value(
            value: cubit,
            child: HomePage(),
          ),
        );
        await tester.ensureVisible(find.byType(BottomNavBar));
        await tester.tap(find.byIcon(Icons.home_outlined));
        verify(() => cubit.setTab(0)).called(1);
      },
    );
  });
}
