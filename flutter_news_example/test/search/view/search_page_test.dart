// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_news_template/feed/feed.dart';
import 'package:flutter_news_template/search/search.dart';
import 'package:flutter_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  late SearchBloc searchBloc;

  setUp(() async {
    searchBloc = MockSearchBloc();

    when(() => searchBloc.state).thenReturn(
      const SearchState(
        articles: [DividerHorizontalBlock()],
        searchType: SearchType.popular,
        status: SearchStatus.initial,
        topics: ['topic'],
      ),
    );
  });

  group('SearchPage', () {
    testWidgets('renders SearchView', (tester) async {
      await tester.pumpApp(const SearchPage());

      expect(find.byType(SearchView), findsOneWidget);
    });
  });

  group('SearchView', () {
    testWidgets('renders filter chips', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      await tester.pump();

      expect(find.byKey(Key('searchFilterChip_topic')), findsOneWidget);
    });

    testWidgets(
        'when SearchFilterChip clicked adds SearchTermChanged to SearchBloc',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      await tester.tap(find.byKey(Key('searchFilterChip_topic')));

      verify(() => searchBloc.add(SearchTermChanged(searchTerm: 'topic')))
          .called(1);
    });

    testWidgets('renders articles', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      expect(find.byType(CategoryFeedItem), findsOneWidget);
    });

    testWidgets('in SearchType.relevant renders two headline titles',
        (tester) async {
      when(() => searchBloc.state).thenReturn(
        const SearchState(
          articles: [],
          searchType: SearchType.relevant,
          status: SearchStatus.initial,
          topics: [],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      expect(find.byType(SearchHeadlineText), findsNWidgets(2));
    });

    testWidgets(
        'when SearchTextField changes to non-empty value '
        'adds SearchTermChanged to SearchBloc', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      await tester.enterText(
        find.byKey(Key('searchPage_searchTextField')),
        'test',
      );

      verify(() => searchBloc.add(SearchTermChanged(searchTerm: 'test')))
          .called(1);
    });

    testWidgets(
        'when SearchTextField changes to an empty value '
        'adds empty SearchTermChanged to SearchBloc', (tester) async {
      when(() => searchBloc.state).thenReturn(
        const SearchState(
          articles: [],
          searchType: SearchType.relevant,
          status: SearchStatus.initial,
          topics: [],
        ),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      await tester.enterText(
        find.byKey(Key('searchPage_searchTextField')),
        '',
      );

      verify(() => searchBloc.add(SearchTermChanged())).called(1);
    });

    testWidgets('shows snackbar when SearchBloc SearchStatus is failure',
        (tester) async {
      final expectedStates = [
        SearchState.initial(),
        SearchState.initial().copyWith(
          status: SearchStatus.failure,
        ),
      ];

      whenListen(searchBloc, Stream.fromIterable(expectedStates));

      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
