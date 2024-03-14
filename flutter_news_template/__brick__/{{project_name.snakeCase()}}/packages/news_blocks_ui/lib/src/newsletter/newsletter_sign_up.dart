import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:news_blocks_ui/src/newsletter/index.dart';

/// {@template newsletter_sign_up}
/// A reusable newsletter news block widget.
/// {@endtemplate}
class NewsletterSignUp extends StatelessWidget {
  /// {@macro newsletter_sign_up}
  const NewsletterSignUp({
    required this.headerText,
    required this.bodyText,
    required this.email,
    required this.buttonText,
    required this.onPressed,
    super.key,
  });

  /// The header displayed message.
  final String headerText;

  /// The body displayed message.
  final String bodyText;

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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            headerText,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: AppColors.highEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            bodyText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: AppColors.mediumEmphasisPrimary),
          ),
          const SizedBox(height: AppSpacing.lg),
          email,
          AppButton.secondary(
            onPressed: onPressed,
            textStyle: theme.textTheme.labelLarge?.copyWith(
              color: AppColors.white,
            ),
            child: Text(
              buttonText,
            ),
          ),
        ],
      ),
    );
  }
}
