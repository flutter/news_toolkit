// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_news_template/feed/widgets/widgets.dart';
import 'package:google_news_template/search/search.dart';
import 'package:google_news_template/search/view/search_page.dart';
import 'package:google_news_template_api/client.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

void main() {
  late SearchBloc searchBloc;

  setUpAll(() async {
    searchBloc = MockSearchBloc();

    when(() => searchBloc.state).thenReturn(
      const SearchState(
        articles: [DividerHorizontalBlock()],
        displayMode: SearchDisplayMode.popular,
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

      expect(find.byType(SearchFilterChip), findsOneWidget);
    });

    testWidgets('when FilterChip clicked adds KeywordChanged to SearchBloc',
        (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      await tester.tap(find.byType(SearchFilterChip));

      verify(() => searchBloc.add(KeywordChanged(keyword: 'topic'))).called(1);
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

    testWidgets('in SearchDisplayMode.relevant renders two titles',
        (tester) async {
      when(() => searchBloc.state).thenReturn(
        const SearchState(
          articles: [],
          displayMode: SearchDisplayMode.relevant,
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
        'when SearchTextField changes to non empty value '
        'emits KeywordChanged on SearchBloc', (tester) async {
      await tester.pumpApp(
        BlocProvider.value(
          value: searchBloc,
          child: const SearchView(),
        ),
      );

      await tester.enterText(
        find.byKey(Key('search_page_search_text_field')),
        'test',
      );

      verify(() => searchBloc.add(KeywordChanged(keyword: 'test'))).called(1);
    });

    testWidgets(
        'when SearchTextField changes to an empty value '
        'emits LoadPopular on SearchBloc', (tester) async {
      when(() => searchBloc.state).thenReturn(
        const SearchState(
          articles: [],
          displayMode: SearchDisplayMode.relevant,
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
        find.byKey(Key('search_page_search_text_field')),
        '',
      );

      verify(() => searchBloc.add(LoadPopular())).called(2);
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
