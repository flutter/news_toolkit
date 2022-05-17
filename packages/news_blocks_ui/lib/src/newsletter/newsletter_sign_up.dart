import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

/// {@template newsletter_sign_up}
/// A reusable newsletter news block widget.
/// {@endtemplate}
class NewsletterSignUp extends StatelessWidget {
  /// {@macro newsletter_sign_up}
  const NewsletterSignUp({
    super.key,
    required this.header,
    required this.body,
    required this.email,
    required this.buttonText,
    required this.onPressed,
  });

  /// The header displayed message.
  final String header;

  /// The body displayed message.
  final String body;

  /// The header displayed message.
  final Widget email;

  /// The text displayed in button.
  final String buttonText;

  /// The callback which is invoked when the button is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return NewsletterContainer(
      child: Column(
        children: [
          Text(
            header,
            textAlign: TextAlign.center,
            style: theme.textTheme.headline4
                ?.copyWith(color: AppColors.highEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyText1
                ?.copyWith(color: AppColors.mediumEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          email,
          AppButton.secondary(
            onPressed: onPressed,
            textStyle: theme.textTheme.button?.copyWith(color: AppColors.white),
            child: Text(
              buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
