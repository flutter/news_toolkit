import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/article/article.dart';
import 'package:news_repository/news_repository.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key, required this.id});

  /// The id of the requested article.
  final String id;

  static Route route({required String id}) =>
      MaterialPageRoute<void>(builder: (_) => ArticlePage(id: id));

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ArticleBloc>(
      create: (_) => ArticleBloc(
        newsRepository: context.read<NewsRepository>(),
      )..add(ArticleRequested(id: id)),
      child: const ArticleView(),
    );
  }
}

class ArticleView extends StatelessWidget {
  const ArticleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
      ),
      body: const SizedBox(),
    );
  }
}
