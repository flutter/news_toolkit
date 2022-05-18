import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/article/article.dart';
import 'package:google_news_template/l10n/l10n.dart';

class ArticleContent extends StatelessWidget {
  const ArticleContent({super.key});

  @override
  Widget build(BuildContext context) {
    final status = context.select((ArticleBloc bloc) => bloc.state.status);
    final content = context.select((ArticleBloc bloc) => bloc.state.content);
    final hasMoreContent =
        context.select((ArticleBloc bloc) => bloc.state.hasMoreContent);

    if (status == ArticleStatus.initial || status == ArticleStatus.loading) {
      return const ArticleContentLoaderItem(
        key: Key('articleContent_empty'),
      );
    }

    return BlocListener<ArticleBloc, ArticleState>(
      listener: (context, state) {
        if (state.status == ArticleStatus.failure) {
          _handleFailure(context);
        }
      },
      child: ListView.builder(
        itemCount: content.length + 1,
        itemBuilder: (context, index) {
          if (index == content.length) {
            return hasMoreContent
                ? Padding(
                    padding: EdgeInsets.only(
                      top: content.isEmpty ? AppSpacing.xxxlg : 0,
                    ),
                    child: ArticleContentLoaderItem(
                      key: ValueKey(index),
                      onPresented: () =>
                          context.read<ArticleBloc>().add(ArticleRequested()),
                    ),
                  )
                : const SizedBox();
          }

          final block = content[index];
          return ArticleContentItem(block: block);
        },
      ),
    );
  }

  void _handleFailure(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          key: const Key('articleContent_failure_snackBar'),
          content: Text(
            context.l10n.unexpectedFailure,
          ),
        ),
      );
  }
}
