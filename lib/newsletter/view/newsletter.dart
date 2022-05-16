import 'package:app_ui/app_ui.dart' hide Assets;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/newsletter/newsletter.dart';
import 'package:news_blocks_ui/news_blocks_ui.dart';
import 'package:news_repository/news_repository.dart';

class Newsletter extends StatelessWidget {
  const Newsletter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewsletterBloc>.value(
      value: NewsletterBloc(
        newsRepository: context.read<NewsRepository>(),
      ),
      child: const NewsletterView(),
    );
  }
}

class NewsletterView extends StatelessWidget {
  const NewsletterView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NewsletterBloc, NewsletterState>(
      bloc: context.read<NewsletterBloc>(),
      listener: (context, state) {
        if (state.status == NewsletterStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(context.l10n.subscribeErrorMessage)),
            );
        }
      },
      builder: (context, state) {
        if (state.status == NewsletterStatus.success) {
          return NewsletterSuccess(
            header: context.l10n.subscribeSuccessfulHeader,
            center: SizedBox(
              height: AppSpacing.xxxlg + AppSpacing.md,
              width: AppSpacing.xxxlg + AppSpacing.md,
              child: Assets.images.magicLinkPromptEmail.svg(),
            ),
            footer: context.l10n.subscribeSuccessfulEmailBody,
          );
        }
        return NewsletterSignUp(
          header: context.l10n.subscribeEmailHeader,
          body: context.l10n.subscribeEmailBody,
          email: AppEmailTextField(
            hintText: context.l10n.subscribeEmailHint,
            onChanged: (email) =>
                context.read<NewsletterBloc>().add(EmailChanged(email: email)),
          ),
          isSubmitEnabled: context.watch<NewsletterBloc>().state.isValid,
          buttonText: context.l10n.subscribeEmailButtonText,
          onPressed: context
                  .select<NewsletterBloc, bool>((bloc) => bloc.state.isValid)
              ? () => context.read<NewsletterBloc>().add(NewsletterSubscribed())
              : null,
        );
      },
    );
  }
}
