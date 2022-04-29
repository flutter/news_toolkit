import 'package:flutter/material.dart';
import 'package:google_news_template/login/login.dart';

class AppTOSModal extends StatelessWidget {
  const AppTOSModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 48.0,
        horizontal: 8.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 24.0,
                ),
                child: Text(
                  'Terms of Use &\n Privacy Policy',
                  style: theme.textTheme.headline5,
                ),
              )
            ],
          ),
          Flexible(
            child: ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(tosText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
