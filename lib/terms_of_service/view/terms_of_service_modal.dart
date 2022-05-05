import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

part '../terms_of_service_mock_text.dart';

class TermsOfServiceModal extends StatelessWidget {
  const TermsOfServiceModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.lg,
        horizontal: AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          TermsOfServiceModalHeader(),
          TermsOfServiceModalBody(),
        ],
      ),
    );
  }
}

@visibleForTesting
class TermsOfServiceModalHeader extends StatelessWidget {
  const TermsOfServiceModalHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          key: const Key('termsOfServiceModal_closeButton'),
          padding: const EdgeInsets.only(
            bottom: AppSpacing.lg,
          ),
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: AppSpacing.md,
          ),
          child: Text(
            context.l10n.loginWithEmailTOSModalTitle,
            style: theme.textTheme.headline5,
          ),
        )
      ],
    );
  }
}

@visibleForTesting
class TermsOfServiceModalBody extends StatelessWidget {
  const TermsOfServiceModalBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
            vertical: AppSpacing.xs,
          ),
          child: Text(termsOfServiceMockText),
        ),
      ),
    );
  }
}
