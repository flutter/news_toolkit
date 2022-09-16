import 'package:flutter/material.dart';

part '../terms_of_service_mock_text.dart';

@visibleForTesting
class TermsOfServiceBody extends StatelessWidget {
  const TermsOfServiceBody({
    super.key,
    this.contentPadding = EdgeInsets.zero,
  });

  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: SingleChildScrollView(
        child: Padding(
          padding: contentPadding,
          child: const Text(
            termsOfServiceMockText,
            key: Key('termsOfServiceBody_text'),
          ),
        ),
      ),
    );
  }
}
