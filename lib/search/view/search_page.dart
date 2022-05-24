import 'package:app_ui/app_ui.dart' hide Assets;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/feed/feed.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/navigation/navigation.dart';
import 'package:google_news_template/search/search.dart';
import 'package:google_news_template/user_profile/user_profile.dart';
import 'package:news_repository/news_repository.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
        newsRepository: context.read<NewsRepository>(),
      )..add(LoadPopular()),
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
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    _controller.addListener(() {
      _controller.text.isEmpty
          ? context.read<SearchBloc>().add(LoadPopular())
          : context
              .read<SearchBloc>()
              .add(KeywordChanged(keyword: _controller.text));
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
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
        return Scaffold(
          appBar: AppBar(
            title: AppLogo.dark(),
            centerTitle: true,
            actions: const [UserProfileButton()],
          ),
          drawer: const NavigationDrawer(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchTextField(controller: _controller),
                const Divider(),
                SearchHeadlineText(
                  headerText: state.displayMode == SearchDisplayMode.popular
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
                            chipText: topic,
                            onSelected: (text) => _controller.text = text,
                          ),
                        )
                        .toList(),
                  ),
                ),
                const Divider(),
                SearchHeadlineText(
                  headerText: state.displayMode == SearchDisplayMode.popular
                      ? l10n.searchPopularArticles
                      : l10n.searchRelevantArticles,
                ),
                ...state.articles
                    .map<Widget>(
                      (newsBlock) => CategoryFeedItem(block: newsBlock),
                    )
                    .toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
