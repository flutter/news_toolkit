import 'package:app_ui/app_ui.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ArticleThemeOverride extends StatelessWidget {
  const ArticleThemeOverride({
    super.key,
    required this.isVideoArticle,
    required this.child,
  });

  final bool isVideoArticle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textHighColor = isVideoArticle
        ? AppColors.highEmphasisPrimary
        : AppColors.highEmphasisSurface;

    final textMediumColor = isVideoArticle
        ? AppColors.mediumEmphasisPrimary
        : AppColors.mediumEmphasisSurface;

    return ContentThemeOverrideBuilder(
      builder: (context) {
        final theme = Theme.of(context);
        final textTheme = theme.textTheme;
        return Theme(
          data: theme.copyWith(
            extensions: [
              ArticleThemeColors(
                captionNormal: textHighColor,
                captionLight: textMediumColor,
              ),
            ],
            textTheme: textTheme.copyWith(
              headline2: textTheme.headline2?.copyWith(color: textHighColor),
              headline6: textTheme.headline6?.copyWith(color: textHighColor),
              bodyText1: textTheme.bodyText1?.copyWith(color: textMediumColor),
            ),
          ),
          child: child,
        );
      },
    );
  }
}

class ArticleThemeColors extends ThemeExtension<ArticleThemeColors>
    with EquatableMixin {
  const ArticleThemeColors({
    required this.captionNormal,
    required this.captionLight,
  });

  final Color captionNormal;
  final Color captionLight;

  @override
  ArticleThemeColors copyWith({
    Color? captionNormal,
    Color? captionLight,
  }) {
    return ArticleThemeColors(
      captionNormal: captionNormal ?? this.captionNormal,
      captionLight: captionLight ?? this.captionLight,
    );
  }

  @override
  ArticleThemeColors lerp(ThemeExtension<ArticleThemeColors>? other, double t) {
    if (other is! ArticleThemeColors) {
      return this;
    }
    return ArticleThemeColors(
      captionNormal: Color.lerp(captionNormal, other.captionNormal, t)!,
      captionLight: Color.lerp(captionLight, other.captionLight, t)!,
    );
  }

  @override
  List<Object?> get props => [captionNormal, captionLight];
}
