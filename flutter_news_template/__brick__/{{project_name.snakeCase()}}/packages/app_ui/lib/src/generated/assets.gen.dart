/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/about_icon.svg
  SvgGenImage get aboutIcon => const SvgGenImage('assets/icons/about_icon.svg');

  /// File path: assets/icons/apple.svg
  SvgGenImage get apple => const SvgGenImage('assets/icons/apple.svg');

  /// File path: assets/icons/back_icon.svg
  SvgGenImage get backIcon => const SvgGenImage('assets/icons/back_icon.svg');

  /// File path: assets/icons/best_value.svg
  SvgGenImage get bestValue => const SvgGenImage('assets/icons/best_value.svg');

  /// File path: assets/icons/close_circle.svg
  SvgGenImage get closeCircle =>
      const SvgGenImage('assets/icons/close_circle.svg');

  /// File path: assets/icons/close_circle_filled.svg
  SvgGenImage get closeCircleFilled =>
      const SvgGenImage('assets/icons/close_circle_filled.svg');

  /// File path: assets/icons/email_outline.svg
  SvgGenImage get emailOutline =>
      const SvgGenImage('assets/icons/email_outline.svg');

  /// File path: assets/icons/envelope_open.svg
  SvgGenImage get envelopeOpen =>
      const SvgGenImage('assets/icons/envelope_open.svg');

  /// File path: assets/icons/facebook.svg
  SvgGenImage get facebook => const SvgGenImage('assets/icons/facebook.svg');

  /// File path: assets/icons/google.svg
  SvgGenImage get google => const SvgGenImage('assets/icons/google.svg');

  /// File path: assets/icons/log_in_icon.svg
  SvgGenImage get logInIcon =>
      const SvgGenImage('assets/icons/log_in_icon.svg');

  /// File path: assets/icons/log_out_icon.svg
  SvgGenImage get logOutIcon =>
      const SvgGenImage('assets/icons/log_out_icon.svg');

  /// File path: assets/icons/notifications_icon.svg
  SvgGenImage get notificationsIcon =>
      const SvgGenImage('assets/icons/notifications_icon.svg');

  /// File path: assets/icons/profile_icon.svg
  SvgGenImage get profileIcon =>
      const SvgGenImage('assets/icons/profile_icon.svg');

  /// File path: assets/icons/terms_of_use_icon.svg
  SvgGenImage get termsOfUseIcon =>
      const SvgGenImage('assets/icons/terms_of_use_icon.svg');

  /// File path: assets/icons/twitter.svg
  SvgGenImage get twitter => const SvgGenImage('assets/icons/twitter.svg');

  /// File path: assets/icons/video.svg
  SvgGenImage get video => const SvgGenImage('assets/icons/video.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        aboutIcon,
        apple,
        backIcon,
        bestValue,
        closeCircle,
        closeCircleFilled,
        emailOutline,
        envelopeOpen,
        facebook,
        google,
        logInIcon,
        logOutIcon,
        notificationsIcon,
        profileIcon,
        termsOfUseIcon,
        twitter,
        video
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/continue_with_apple.svg
  SvgGenImage get continueWithApple =>
      const SvgGenImage('assets/images/continue_with_apple.svg');

  /// File path: assets/images/continue_with_facebook.svg
  SvgGenImage get continueWithFacebook =>
      const SvgGenImage('assets/images/continue_with_facebook.svg');

  /// File path: assets/images/continue_with_google.svg
  SvgGenImage get continueWithGoogle =>
      const SvgGenImage('assets/images/continue_with_google.svg');

  /// File path: assets/images/continue_with_twitter.svg
  SvgGenImage get continueWithTwitter =>
      const SvgGenImage('assets/images/continue_with_twitter.svg');

  /// File path: assets/images/logo_dark.png
  AssetGenImage get logoDark =>
      const AssetGenImage('assets/images/logo_dark.png');

  /// File path: assets/images/logo_light.png
  AssetGenImage get logoLight =>
      const AssetGenImage('assets/images/logo_light.png');

  /// List of all assets
  List<dynamic> get values => [
        continueWithApple,
        continueWithFacebook,
        continueWithGoogle,
        continueWithTwitter,
        logoDark,
        logoLight
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package = 'app_ui',
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package = 'app_ui',
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/app_ui/$_assetName';
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package = 'app_ui',
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/app_ui/$_assetName';
}
