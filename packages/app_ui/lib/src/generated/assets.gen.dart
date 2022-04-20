/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// ignore_for_file: directives_ordering,unnecessary_import

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/apple.png
  AssetGenImage get apple => const AssetGenImage('assets/icons/apple.png');

  /// File path: assets/icons/email_outline.png
  AssetGenImage get emailOutline =>
      const AssetGenImage('assets/icons/email_outline.png');

  /// File path: assets/icons/facebook.png
  AssetGenImage get facebook =>
      const AssetGenImage('assets/icons/facebook.png');

  /// File path: assets/icons/google.png
  AssetGenImage get google => const AssetGenImage('assets/icons/google.png');

  /// File path: assets/icons/mail_outline.png
  AssetGenImage get mailOutline =>
      const AssetGenImage('assets/icons/mail_outline.png');

  /// File path: assets/icons/twitter.png
  AssetGenImage get twitter => const AssetGenImage('assets/icons/twitter.png');
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/continue_with_apple.png
  AssetGenImage get continueWithApple =>
      const AssetGenImage('assets/images/continue_with_apple.png');

  /// File path: assets/images/continue_with_facebook.png
  AssetGenImage get continueWithFacebook =>
      const AssetGenImage('assets/images/continue_with_facebook.png');

  /// File path: assets/images/continue_with_google.png
  AssetGenImage get continueWithGoogle =>
      const AssetGenImage('assets/images/continue_with_google.png');

  /// File path: assets/images/continue_with_twitter.png
  AssetGenImage get continueWithTwitter =>
      const AssetGenImage('assets/images/continue_with_twitter.png');

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

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName, package: 'app_ui');

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
