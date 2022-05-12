import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

part '../terms_of_service_mock_text.dart';

@visibleForTesting
class TermsOfServiceBody extends StatelessWidget {
  const TermsOfServiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Flexible(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.xlg,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            termsOfServiceMockText,
            key: Key('termsOfServiceBody_text'),
          ),
        ),
      ),
    );
  }
}
