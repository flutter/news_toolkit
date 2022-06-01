import 'package:app_ui/app_ui.dart' show AppColors, AppSpacing;
import 'package:flutter/material.dart';
import 'package:google_news_template/generated/generated.dart';
import 'package:google_news_template/l10n/l10n.dart';

class NavigationDrawerSections extends StatelessWidget {
  const NavigationDrawerSections({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const NavigationDrawerSectionsTitle(),
        const NavigationDrawerSectionItem(
          title: 'Top Stories',
          selected: true,
        ),
        const NavigationDrawerSectionItem(
          title: 'Technology',
        ),
        const NavigationDrawerSectionItem(
          title: 'Sports',
        ),
        NavigationDrawerSectionItem(
          title: 'Subscriber Exclusives',
          leading: Assets.icons.lockedContentIcon.svg(),
        ),
      ],
    );
  }
}

@visibleForTesting
class NavigationDrawerSectionsTitle extends StatelessWidget {
  const NavigationDrawerSectionsTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg + AppSpacing.xxs,
        ),
        child: Text(
          context.l10n.navigationDrawerSectionsTitle,
          style: Theme.of(context).textTheme.subtitle1?.copyWith(
                color: AppColors.primaryContainer,
              ),
        ),
      ),
    );
  }
}

@visibleForTesting
class NavigationDrawerSectionItem extends StatelessWidget {
  const NavigationDrawerSectionItem({
    super.key,
    required this.title,
    this.onTap,
    this.leading,
    this.selected = false,
  });

  static const _borderRadius = 100.0;

  final String title;
  final Widget? leading;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: leading,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: selected ? AppSpacing.xlg : AppSpacing.lg,
        vertical: AppSpacing.lg + AppSpacing.xxs,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(_borderRadius),
        ),
      ),
      horizontalTitleGap: AppSpacing.md,
      minLeadingWidth: AppSpacing.xlg,
      selectedTileColor: AppColors.white.withOpacity(0.08),
      selected: selected,
      onTap: onTap,
      title: Text(
        title,
        style: Theme.of(context).textTheme.button?.copyWith(
              color: selected
                  ? AppColors.highEmphasisPrimary
                  : AppColors.mediumEmphasisPrimary,
            ),
      ),
    );
  }
}
