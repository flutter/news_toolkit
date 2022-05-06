import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';
import 'package:google_news_template/terms_of_service/widgets/widgets.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const TermsOfServicePage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('termsOfService_closeIcon'),
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TermsOfServiceHeader(),
          TermsOfServiceBody(),
          SizedBox(height: AppSpacing.lg)
        ],
      ),
    );
  }
}

@visibleForTesting
class TermsOfServiceHeader extends StatelessWidget {
  const TermsOfServiceHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xlg,
        vertical: AppSpacing.lg,
      ),
      child: Text(
        context.l10n.termsOfServiceModalTitle,
        style: theme.textTheme.headline4,
      ),
    );
  }
}
