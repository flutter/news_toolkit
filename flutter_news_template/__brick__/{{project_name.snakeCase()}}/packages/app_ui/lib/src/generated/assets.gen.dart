/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/apple.svg
  SvgGenImage get apple => const SvgGenImage('assets/icons/apple.svg');

  /// File path: assets/icons/back_icon.svg
  SvgGenImage get backIcon => const SvgGenImage('assets/icons/back_icon.svg');

  /// File path: assets/icons/close_circle.svg
  SvgGenImage get closeCircle =>
      const SvgGenImage('assets/icons/close_circle.svg');

  /// File path: assets/icons/close_circle_filled.svg
  SvgGenImage get closeCircleFilled =>
      const SvgGenImage('assets/icons/close_circle_filled.svg');

  /// File path: assets/icons/email_outline.svg
  SvgGenImage get emailOutline =>
      const SvgGenImage('assets/icons/email_outline.svg');

  /// File path: assets/icons/facebook.svg
  SvgGenImage get facebook => const SvgGenImage('assets/icons/facebook.svg');

  /// File path: assets/icons/google.svg
  SvgGenImage get google => const SvgGenImage('assets/icons/google.svg');

  /// File path: assets/icons/twitter.svg
  SvgGenImage get twitter => const SvgGenImage('assets/icons/twitter.svg');
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
    double? scale = 1.0,
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

  String get path => _assetName;
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
    Color? color,
    BlendMode colorBlendMode = BlendMode.srcIn,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    Clip clipBehavior = Clip.hardEdge,
    bool cacheColorFilter = false,
    SvgTheme? theme,
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
      color: color,
      colorBlendMode: colorBlendMode,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
      theme: theme,
    );
  }

  String get path => _assetName;
}
