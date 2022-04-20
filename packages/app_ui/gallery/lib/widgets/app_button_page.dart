import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppButtonPage extends StatelessWidget {
  const AppButtonPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AppButtonPage());
  }

  @override
  Widget build(BuildContext context) {
    final appButtonList = [
      _AppButtonItem(
        buttonType: ButtonType.google,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.google.image(),
            const SizedBox(width: AppSpacing.lg),
            const Text('Continue with Google'),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.apple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.apple.image(),
            const SizedBox(width: AppSpacing.lg),
            const Text('Continue with Apple'),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.facebook,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.facebook.image(),
            const SizedBox(width: AppSpacing.lg),
            const Text('Continue with Facebook'),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.twitter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.twitter.image(),
            const SizedBox(width: AppSpacing.lg),
            const Text('Continue with Twitter'),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.email,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.emailOutline.image(),
            const SizedBox(width: AppSpacing.lg),
            const Text('Continue with Email'),
          ],
        ),
      ),
      const _AppButtonItem(
        buttonType: ButtonType.login,
        child: Text('Log in'),
      ),
      const _AppButtonItem(
        buttonType: ButtonType.subscribe,
        child: Text('Subscribe'),
      ),
      const _AppButtonItem(
        buttonType: ButtonType.information,
        child: Text('Next'),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('App Buttons')),
      body: ListView(shrinkWrap: true, children: appButtonList),
    );
  }
}

enum ButtonType {
  google,
  apple,
  facebook,
  twitter,
  email,
  login,
  subscribe,
  information
}

class _AppButtonItem extends StatelessWidget {
  const _AppButtonItem({
    Key? key,
    required this.buttonType,
    required this.child,
  }) : super(key: key);

  AppButton get appButton {
    switch (buttonType) {
      case ButtonType.google:
        return AppButton.outlinedWhite(
          onPressed: () {},
          child: child,
        );
      case ButtonType.apple:
        return AppButton.black(
          child: child,
          onPressed: () {},
        );
      case ButtonType.facebook:
        return AppButton.blueDress(
          child: child,
          onPressed: () {},
        );
      case ButtonType.twitter:
        return AppButton.crystalBlue(
          child: child,
          onPressed: () {},
        );

      case ButtonType.email:
        return AppButton.outlinedTransparent(
          child: child,
          onPressed: () {},
        );
      case ButtonType.login:
        return AppButton.outlinedTransparent(
          child: child,
          onPressed: () {},
        );
      case ButtonType.subscribe:
        return AppButton.redWine(
          child: child,
          onPressed: () {},
        );
      case ButtonType.information:
        return AppButton.darkAqua(
          child: child,
          onPressed: () {},
        );
    }
  }

  final Widget child;
  final ButtonType buttonType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: appButton,
    );
  }
}
