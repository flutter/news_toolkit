// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_example/app/app.dart';
import 'package:flutter_news_example/categories/categories.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/login/login.dart';
import 'package:flutter_news_example/navigation/navigation.dart';
import 'package:flutter_news_example/onboarding/onboarding.dart';
import 'package:flutter_news_example/search/search.dart';
import 'package:flutter_news_example/user_profile/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class MockCategoriesBloc extends MockBloc<CategoriesEvent, CategoriesState>
    implements CategoriesBloc {}

class MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

class MockNewsRepository extends Mock implements NewsRepository {}

class MockAppBloc extends Mock implements AppBloc {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  initMockHydratedStorage();

  late NewsRepository newsRepository;
  late HomeCubit cubit;
  late CategoriesBloc categoriesBloc;
  late FeedBloc feedBloc;
  late AppBloc appBloc;
  late GoRouter goRouter;

  final entertainmentCategory = Category(
    id: 'entertainment',
    name: 'Entertainment',
  );
  final healthCategory = Category(id: 'health', name: 'Health');

  final categories = [entertainmentCategory, healthCategory];

  final feed = <String, List<NewsBlock>>{
    entertainmentCategory.id: [
      SectionHeaderBlock(title: 'Top'),
      DividerHorizontalBlock(),
      SpacerBlock(spacing: Spacing.medium),
    ],
    healthCategory.id: [
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
    appBloc = MockAppBloc();
    goRouter = MockGoRouter();

    when(() => appBloc.state).thenReturn(
      AppState(
        showLoginOverlay: false,
        status: AppStatus.unauthenticated,
      ),
    );

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
        categories: [healthCategory],
      ),
    );

    when(() => cubit.state).thenReturn(HomeState.topStories);
  });
  group('HomeView', () {
    testWidgets('renders AppBar with AppLogo', (tester) async {
      when(() => cubit.state).thenReturn(HomeState.topStories);

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
        categoriesBloc: categoriesBloc,
        feedBloc: feedBloc,
        newsRepository: newsRepository,
      );

      expect(
        find.byWidgetPredicate(
          (widget) => widget is AppBar && widget.title is AppLogo,
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders UserProfileButton', (tester) async {
      when(() => cubit.state).thenReturn(HomeState.topStories);

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
        categoriesBloc: categoriesBloc,
        feedBloc: feedBloc,
        newsRepository: newsRepository,
      );

      expect(find.byType(UserProfileButton), findsOneWidget);
    });

    testWidgets(
        'renders NavDrawer '
        'when menu icon is tapped', (tester) async {
      when(() => cubit.state).thenReturn(HomeState.topStories);

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
        categoriesBloc: categoriesBloc,
        feedBloc: feedBloc,
        newsRepository: newsRepository,
      );

      expect(find.byType(NavDrawer), findsNothing);

      await tester.tap(find.byIcon(Icons.menu));
      await tester.pump();

      expect(find.byType(NavDrawer), findsOneWidget);
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

    testWidgets('shows LoginOverlay when showLoginOverlay is true',
        (tester) async {
      whenListen(
        appBloc,
        Stream.fromIterable([
          AppState(status: AppStatus.unauthenticated, showLoginOverlay: false),
          AppState(status: AppStatus.unauthenticated, showLoginOverlay: true),
        ]),
      );

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
        categoriesBloc: categoriesBloc,
        feedBloc: feedBloc,
        newsRepository: newsRepository,
        appBloc: appBloc,
      );

      expect(find.byType(LoginModal), findsOneWidget);
    });

    testWidgets('navigates to Onboarding page if onboarding is required',
        (tester) async {
      whenListen(
        appBloc,
        Stream.fromIterable([
          AppState(
            showLoginOverlay: false,
            status: AppStatus.onboardingRequired,
          ),
        ]),
      );
      when(() => goRouter.goNamed(OnboardingPage.routePath)).thenAnswer((_) {});

      await pumpHomeView(
        tester: tester,
        cubit: cubit,
        categoriesBloc: categoriesBloc,
        feedBloc: feedBloc,
        newsRepository: newsRepository,
        appBloc: appBloc,
        goRouter: goRouter,
      );

      verify(() => goRouter.goNamed(OnboardingPage.routePath)).called(1);
    });
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
        await tester.tap(find.byKey(Key('bottomNavBar_search')));
        verify(() => cubit.setTab(1)).called(1);
      },
    );

    testWidgets(
      'unfocuses keyboard when tab is changed.',
      (tester) async {
        final controller = StreamController<HomeState>();
        whenListen(
          cubit,
          controller.stream,
          initialState: HomeState.topStories,
        );
        await pumpHomeView(
          tester: tester,
          cubit: cubit,
          categoriesBloc: categoriesBloc,
          feedBloc: feedBloc,
          newsRepository: newsRepository,
        );

        await tester.ensureVisible(find.byType(BottomNavBar));
        await tester.tap(find.byKey(Key('bottomNavBar_search')));
        verify(() => cubit.setTab(1)).called(1);

        controller.add(HomeState.search);

        await tester.pump(kThemeAnimationDuration);
        await tester.showKeyboard(find.byType(SearchTextField));

        final initialFocus = tester.binding.focusManager.primaryFocus;

        controller.add(HomeState.topStories);
        await tester.pump();

        expect(
          tester.binding.focusManager.primaryFocus,
          isNot(equals(initialFocus)),
        );
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
  AppBloc? appBloc,
  GoRouter? goRouter,
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
      child: goRouter != null
          ? InheritedGoRouter(goRouter: goRouter, child: HomeView())
          : HomeView(),
    ),
    newsRepository: newsRepository,
    appBloc: appBloc,
  );
}
