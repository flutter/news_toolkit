import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:google_news_template/l10n/l10n.dart';

import '../widgets/widgets.dart';

class TermsOfServiceSettingsPage extends StatelessWidget {
  const TermsOfServiceSettingsPage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute<void>(
        builder: (_) => const TermsOfServiceSettingsPage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          TermsOfServiceSettingsHeader(),
          TermsOfServiceBody(),
          SizedBox(height: AppSpacing.lg)
        ],
      ),
    );
  }
}

class TermsOfServiceSettingsHeader extends StatelessWidget {
  const TermsOfServiceSettingsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Text(
        context.l10n.termsOfServiceModalTitle,
        style: theme.textTheme.headline4,
      ),
    );
  }
}
