import 'package:app_ui/app_ui.dart' hide Assets;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/app/app.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/search/search.dart';
import 'package:news_repository/news_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        newsRepository: context.read<NewsRepository>(),
      )..add(const SearchTermChanged()),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () => context
          .read<SearchBloc>()
          .add(SearchTermChanged(searchTerm: _controller.text)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isUserSubscribed =
        context.select((AppBloc bloc) => bloc.state.isUserSubscribed);

    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.status == SearchStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.l10n.searchErrorMessage)),
            );
        }
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchTextField(
                key: const Key('searchPage_searchTextField'),
                controller: _controller,
              ),
              const Divider(),
              SearchHeadlineText(
                headerText: state.searchType == SearchType.popular
                    ? l10n.searchPopularSearches
                    : l10n.searchRelevantTopics,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  0,
                  AppSpacing.lg,
                  AppSpacing.lg,
                ),
                child: Wrap(
                  spacing: AppSpacing.sm,
                  children: state.topics
                      .map<Widget>(
                        (topic) => SearchFilterChip(
                          key: Key('searchFilterChip_$topic'),
                          chipText: topic,
                          onSelected: (text) => _controller.text = text,
                        ),
                      )
                      .toList(),
                ),
              ),
              const Divider(),
              SearchHeadlineText(
                headerText: state.searchType == SearchType.popular
                    ? l10n.searchPopularArticles
                    : l10n.searchRelevantArticles,
              ),
              ...state.articles
                  .map<Widget>(
                    (newsBlock) => CategoryFeedItem(
                      block: newsBlock,
                      isUserSubscribed: isUserSubscribed,
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
