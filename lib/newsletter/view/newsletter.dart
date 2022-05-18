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
    return BlocProvider<NewsletterBloc>(
      create: (context) => NewsletterBloc(
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
    final isEmailValid =
        context.select<NewsletterBloc, bool>((bloc) => bloc.state.isValid);
    return BlocConsumer<NewsletterBloc, NewsletterState>(
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
          return NewsletterSucceeded(
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
          buttonText: context.l10n.subscribeEmailButtonText,
          onPressed: isEmailValid
              ? () => context.read<NewsletterBloc>().add(NewsletterSubscribed())
              : null,
        );
      },
    );
  }
}
