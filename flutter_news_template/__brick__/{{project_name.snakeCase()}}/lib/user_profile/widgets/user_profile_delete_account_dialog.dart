import 'package:app_ui/app_ui.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{project_name.snakeCase()}}/app/app.dart';
import 'package:{{project_name.snakeCase()}}/l10n/l10n.dart';

class UserProfileDeleteAccountDialog extends StatelessWidget {
  const UserProfileDeleteAccountDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(
        l10n.deleteAccountDialogTitle,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      content: Text(
        l10n.deleteAccountDialogSubtitle,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      actions: <Widget>[
        AppButton.smallDarkAqua(
          key: const Key('userProfilePage_cancelDeleteAccountButton'),
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(l10n.deleteAccountDialogCancelButtonText),
        ),
        AppButton.smallRedWine(
          key: const Key('userProfilePage_deleteAccountButton'),
          onPressed: () {
            context.read<AppBloc>().add(const AppDeleteAccountRequested());
            Navigator.of(context).pop();
          },
          child: Text(l10n.userProfileDeleteAccountButton),
        ),
      ],
    );
  }
}
