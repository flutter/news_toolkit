// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_news_example/feed/feed.dart';
import 'package:flutter_news_example/home/home.dart';
import 'package:flutter_news_example/network_error/network_error.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_blocks/news_blocks.dart';
import 'package:news_repository/news_repository.dart';

import '../../helpers/helpers.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

class MockGoRouter extends Mock implements GoRouter {}

class _MockGoRouterState extends Mock implements GoRouterState {}

class _MockBuildContext extends Mock implements BuildContext {}

class MockFeedBloc extends MockBloc<FeedEvent, FeedState> implements FeedBloc {}

void main() {
  initMockHydratedStorage();

  late NewsRepository newsRepository;
  late FeedBloc feedBloc;

  final entertainmentCategory = Category(
    id: 'entertainment',
    name: 'Entertainment',
  );
  final healthCategory = Category(id: 'health', name: 'Health');

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

  initMockHydratedStorage();
  late GoRouter router;
  late GoRouterState goRouterState;
  late BuildContext context;

  setUp(() {
    feedBloc = MockFeedBloc();

    when(() => feedBloc.state).thenReturn(
      FeedState(
        feed: feed,
        status: FeedStatus.populated,
      ),
    );

    newsRepository = MockNewsRepository();
    router = MockGoRouter();
    goRouterState = _MockGoRouterState();
    context = _MockBuildContext();
    final healthCategory = Category(id: 'health', name: 'Health');

    when(newsRepository.getCategories).thenAnswer(
      (_) async => CategoriesResponse(
        categories: [healthCategory],
      ),
    );

    when(
      () => router.pushNamed(
        NetworkErrorPage.routePath,
      ),
    ).thenAnswer((_) async {
      return null;
    });
  });

  testWidgets('routeBuilder builds a HomePage', (tester) async {
    final page = HomePage.routeBuilder(context, goRouterState);

    expect(page, isA<HomePage>());
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
