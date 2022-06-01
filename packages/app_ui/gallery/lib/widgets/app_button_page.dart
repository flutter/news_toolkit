import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class AppButtonPage extends StatelessWidget {
  const AppButtonPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const AppButtonPage());
  }

  @override
  Widget build(BuildContext context) {
    const _contentSpacing = AppSpacing.lg;
    final appButtonList = [
      _AppButtonItem(
        buttonType: ButtonType.google,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.google.svg(),
            const SizedBox(width: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xxs),
              child: Assets.images.continueWithGoogle.svg(),
            ),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.apple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.apple.svg(),
            const SizedBox(width: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Assets.images.continueWithApple.svg(),
            ),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.facebook,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.facebook.svg(),
            const SizedBox(width: AppSpacing.lg),
            Assets.images.continueWithFacebook.svg(),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.twitter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.twitter.svg(),
            const SizedBox(width: AppSpacing.lg),
            Assets.images.continueWithTwitter.svg(),
          ],
        ),
      ),
      _AppButtonItem(
        buttonType: ButtonType.email,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Assets.icons.emailOutline.svg(),
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
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + _contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.trial,
          child: Text('Start free trial'),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + _contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.logout,
          child: Text('Logout'),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + _contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.details,
          child: Text('View details'),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg + _contentSpacing,
        ),
        child: _AppButtonItem(
          buttonType: ButtonType.cancel,
          child: Text('Cancel anytime'),
        ),
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
  information,
  trial,
  logout,
  details,
  cancel,
}

class _AppButtonItem extends StatelessWidget {
  const _AppButtonItem({required this.buttonType, required this.child});

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
          onPressed: () {},
          child: child,
        );
      case ButtonType.email:
        return AppButton.outlinedTransparent(
          onPressed: () {},
          child: child,
        );
      case ButtonType.login:
        return AppButton.outlinedTransparent(
          onPressed: () {},
          child: child,
        );
      case ButtonType.subscribe:
        return AppButton.redWine(
          child: child,
          onPressed: () {},
        );
      case ButtonType.information:
        return AppButton.darkAqua(
          onPressed: () {},
          child: child,
        );
      case ButtonType.trial:
        return AppButton.smallRedWine(
          onPressed: () {},
          child: child,
        );
      case ButtonType.logout:
        return AppButton.smallDarkAqua(
          onPressed: () {},
          child: child,
        );
      case ButtonType.details:
        return AppButton.smallOutlineTransparent(
          onPressed: () {},
          child: child,
        );
      case ButtonType.cancel:
        return AppButton.smallTransparent(
          onPressed: () {},
          child: child,
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
