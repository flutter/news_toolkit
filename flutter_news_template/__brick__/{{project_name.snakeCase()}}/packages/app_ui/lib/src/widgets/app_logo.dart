import 'package:app_ui/src/generated/generated.dart';
import 'package:flutter/material.dart';

/// {@template app_logo}
/// A default app logo.
/// {@endtemplate}
class AppLogo extends StatelessWidget {
  /// {@macro app_logo}
  const AppLogo._({required AssetGenImage logo, super.key}) : _logo = logo;

  /// The dark app logo.
  AppLogo.dark({Key? key}) : this._(key: key, logo: Assets.images.logoDark);

  /// The light app logo.
  AppLogo.light({Key? key}) : this._(key: key, logo: Assets.images.logoLight);

  /// The logo to be displayed.
  final AssetGenImage _logo;

  @override
  Widget build(BuildContext context) {
    return _logo.image(
      fit: BoxFit.contain,
      width: 172,
      height: 24,
    );
  }
}
