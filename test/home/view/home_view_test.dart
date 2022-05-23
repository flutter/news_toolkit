// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/categories/categories.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/home/home.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template_api/api.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late NewsRepository newsRepository;
  late HomeCubit cubit;
  late CategoriesBloc categoriesBloc;
  late FeedBloc feedBloc;

  const categories = [Category.top, Category.technology];

  final feed = <Category, List<NewsBlock>>{
    Category.top: [
      SectionHeaderBlock(title: 'Top'),
      DividerHorizontalBlock(),
      SpacerBlock(spacing: Spacing.medium),
    ],
    Category.technology: [
      SectionHeaderBlock(title: 'Technology'),
      DividerHorizontalBlock(),
      SpacerBlock(spacing: Spacing.medium),
    ],
  };

  setUp(() {
    newsRepository = MockNewsRepository();

    categoriesBloc = MockCategoriesBloc();
    feedBloc = MockFeedBloc();
    cubit = MockHomeCubit();

    when(() => categoriesBloc.state).thenReturn(
      CategoriesState(
        categories: categories,
        status: CategoriesStatus.populated,
      ),
    );

    when(() => feedBloc.state).thenReturn(
      FeedState(
        feed: feed,
        status: FeedStatus.populated,
      ),
    );

    when(newsRepository.getCategories).thenAnswer(
      (_) async => CategoriesResponse(
        categories: [Category.top],
      ),
    );

    when(() => cubit.state).thenReturn(HomeState.topStories);
  });

  testWidgets('renders FeedView', (tester) async {
    await pumpHomeView(
      tester: tester,
      cubit: cubit,
      categoriesBloc: categoriesBloc,
      feedBloc: feedBloc,
      newsRepository: newsRepository,
    );
    expect(find.byType(FeedView), findsOneWidget);
  });

  group('BottomNavigationBar', () {
    testWidgets(
      'has selected index to 0 by default.',
      (tester) async {
        when(() => cubit.state).thenReturn(HomeState.topStories);

        await pumpHomeView(
          tester: tester,
          cubit: cubit,
          categoriesBloc: categoriesBloc,
          feedBloc: feedBloc,
          newsRepository: newsRepository,
        );

        expect(find.byType(FeedView), findsOneWidget);
      },
    );

    testWidgets(
      'set tab to selected index 0 when top stories is tapped.',
      (tester) async {
        await pumpHomeView(
          tester: tester,
          cubit: cubit,
          categoriesBloc: categoriesBloc,
          feedBloc: feedBloc,
          newsRepository: newsRepository,
        );
        await tester.ensureVisible(find.byType(BottomNavBar));
        await tester.tap(find.byIcon(Icons.home_outlined));
        verify(() => cubit.setTab(0)).called(1);
      },
    );

    testWidgets(
      'set tab to selected index 1 when search is tapped.',
      (tester) async {
        await pumpHomeView(
          tester: tester,
          cubit: cubit,
          categoriesBloc: categoriesBloc,
          feedBloc: feedBloc,
          newsRepository: newsRepository,
        );
        await tester.ensureVisible(find.byType(BottomNavBar));
        await tester.tap(find.byIcon(Icons.search));
        verify(() => cubit.setTab(1)).called(1);
      },
    );

    testWidgets(
      'set tab to selected index 2 when subscribe is tapped.',
      (tester) async {
        await pumpHomeView(
          tester: tester,
          cubit: cubit,
          categoriesBloc: categoriesBloc,
          feedBloc: feedBloc,
          newsRepository: newsRepository,
        );
        await tester.ensureVisible(find.byType(BottomNavBar));
        await tester.tap(find.byIcon(Icons.subscriptions_outlined));
        verify(() => cubit.setTab(2)).called(1);
      },
    );
  });
}

Future<void> pumpHomeView({
  required WidgetTester tester,
  required HomeCubit cubit,
  required CategoriesBloc categoriesBloc,
  required FeedBloc feedBloc,
  required NewsRepository newsRepository,
}) async {
  await tester.pumpApp(
    MultiBlocProvider(
      providers: [
        BlocProvider.value(
          value: categoriesBloc,
        ),
        BlocProvider.value(
          value: feedBloc,
        ),
        BlocProvider.value(
          value: cubit,
        ),
      ],
      child: HomeView(),
    ),
    newsRepository: newsRepository,
  );
}
